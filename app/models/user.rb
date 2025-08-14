# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  generates_token_for :password_reset, expires_in: 15.minutes
  generates_token_for :email_confirmation, expires_in: 24.hours

  validates :email, presence: true, email: true, uniqueness: true
  normalizes :email, with: ->(email) { email.strip.downcase }
end
