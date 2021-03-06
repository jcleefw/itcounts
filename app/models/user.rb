class User < ActiveRecord::Base
  has_many :user_goal
  has_many :goals, :through => :user_goal

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :username
  validates_format_of :email, :with => /@/

  def self.authenticate(email, password)
    user = User.find_by(:email => email) || User.find_by(:username => email)
    if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt   = BCrypt::Engine.generate_salt
      self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end
