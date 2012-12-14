class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation
  validates :email, presence: true
  validates_uniqueness_of :email, case_sensitive: false, allow_nil: true
  # validates_format_of :password, with: /((?=.*\d)(?=.*[A-Z]).{8,})/, message: 'must contain at least 1 number and 1 capital letter and be at least 8 characters long', allow_nil: true, on: :standard, if: :password?
  has_many :comments
  ROLES = %w(user admin)

  def role
    @role_inquirer ||= ActiveSupport::StringInquirer.new(self[:role])
  end

  def role= role
    remove_instance_variable :@role_inquirer if defined?(@role_inquirer)
    super
  end

  def password?
    password.present?
  end
end