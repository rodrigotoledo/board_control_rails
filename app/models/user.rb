class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, email: true, uniqueness: true
  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes
  generates_token_for :email_confirmation, expires_in: 24.hours
end
