class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PW_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*_-])\S+\z/
  PW_MIN_LEN = 8
  PW_MAX_LEN = 64   # bcrypt is limited to 72 chars
  private_constant :EMAIL_REGEX, :PW_REGEX

  enum role: {
    regular: 'regular',
    admin: 'admin',
    banned: 'banned'
  }

  has_secure_password
  auto_strip_attributes :first_name, :last_name, :email

  before_validation :downcase_names_and_email

  validates :first_name,  presence: true,
                          format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name,   presence: true,
                          format: { with: /\A[a-zA-Z]+\z/ }
  validates :email,       presence: true,
                          format: { with: EMAIL_REGEX },
                          uniqueness: true
  validates :password,    presence: true,
                          length: { in: PW_MIN_LEN..PW_MAX_LEN },
                          format: { with: PW_REGEX }
  validates :role,        presence: true


  private

    def downcase_names_and_email
      self.first_name.downcase! if first_name.present?
      self.last_name.downcase! if last_name.present?
      self.email.downcase! if email.present?
    end
end
