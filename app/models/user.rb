class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PW_REGEX = /(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*_-])/
  private_constant :EMAIL_REGEX, :PW_REGEX

  has_secure_password
  auto_strip_attributes :first_name, :last_name, :email
end
