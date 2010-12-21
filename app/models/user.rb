class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :jobs
  has_many :clients
  has_and_belongs_to_many :roles

  before_save :ensure_authentication_token

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

end
