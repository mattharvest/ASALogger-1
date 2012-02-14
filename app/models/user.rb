
#id			:integer, not null, primary key
#name		:string, should be the same as the county logon
#email		:string, should be work email
#created_at	:datetime
#updated_at	:datetime
class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation, :unit
	
	has_many :microposts, :dependent => :destroy
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, :presence => true
	validates :unit, :presence => true
	validates :email, :presence => true,
		:format => {:with => email_regex },
		:uniqueness => {:case_sensitive => false }
	validates :password, :presence => true,
		:confirmation => true
		
	before_save :encrypt_password
	
	def has_password? (submitted_password)
		encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	def feed
		Micropost.where("user_id = ?", id)
	end
	
	private
		def encrypt_password
			self.salt = make_salt unless has_password?(password)
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
