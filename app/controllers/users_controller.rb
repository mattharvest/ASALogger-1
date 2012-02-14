class UsersController < ApplicationController
	before_filter :authenticate, 	:only => [:index, :edit, :update, :destroy]
	before_filter :correct_user, 	:only => [:edit, :update]
	before_filter :admin_user, 		:only => :destroy
	
	def new
		@user = User.new
		@title = "Sign up"
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to asaLogger!"
			redirect_to @user
		else
			@title = "Sign up"
			render 'new'
		end
	end
	
	def destroy
		if @user = User.find(params[id])
			flash[:success] = "Found user to destroy."
			User.find(params[:id]).destroy
			flash[:success] = "User destroyed."
		end
		
		redirect_to_users_path
	end
	
	def edit
		@title = "Edit user"
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end
	
	def show
		@user = User.find(params[:id])
		@title = @user.name
		@microposts = @user.microposts.paginate(:page => params[:page])
	end
	
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
