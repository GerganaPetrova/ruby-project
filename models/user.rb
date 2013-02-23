require 'sequel'
require 'bcrypt'
require 'pony'
Sequel::Model.db = Sequel.sqlite './db/db.sqlite'

class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :books
  include BCrypt

  def password
    Password.new(self[:password])
  end

  def password=(new_password)
    self[:password] = Password.create(new_password)
  end

  def send_mail(params)
     Pony.mail :to => params[:email],
               :via => :smtp,
               :via_options => {
                 :address => 'smtp.gmail.com',
                 :port =>'587',
                 :enable_starttls_auto => true,
                 :user_name => 'example.online.reader@gmail.com',
                 :password => 'fakpassword',
                 :authentication => :plain
               },
               :from => 'example.online.reader@gmail.com',
               :subject => "Welcome, #{params[:name]}!",
               :body => "Hello, dumbass!"
  end

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique [:username]
    validates_length_range 5...20, :username
  end

  def self.authenticate(username, password)
    user = User.find(:username => username)
    return user if user.password == password
  end

end
