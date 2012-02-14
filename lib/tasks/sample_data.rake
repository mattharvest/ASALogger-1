namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Admin User",
                 :email => "example@railstutorial.org",
				 :unit => "testunit",
                 :password => "foobar",
                 :password_confirmation => "foobar")
	admin.toggle!(:admin)
    50.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
				   :unit => "testunit",
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
