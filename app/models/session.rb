class Session
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveRecord::Callbacks

  attr_accessor :email, :password, :url_after_login

  before_validation :set_user

  validates_presence_of :email, :password
  validate :account_exists, :correct_password


  def get_user
    user
  end

  def authenticate?
    valid?
  end


  private

    attr_accessor :user

    def set_user
      self.user = User.find_by(email: email)
    end

    def account_exists
      errors.add(:email, "not recognised") if user.nil?
    end

    def correct_password
      if user.present? && !user.authenticate(password)
        errors.add(:password, "incorrect password")
      end
    end
end
