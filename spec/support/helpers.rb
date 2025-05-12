# frozen_string_literal: true

require "factory_bot_rails"
require "shoulda/matchers"
require "rspec/json_expectations"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

module SessionHelpers
  def generate_jwt_token(user)
    { Authorization: bearer_token(user) }
  end

  def generate_invalid_jwt_token
    { Authorization: bearer_token }
  end

  def bearer_token(user = nil)
    payload = { user_id: user.try(:id) }
    token = encode_token(payload)
    "Bearer #{token}"
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.dig(:jwt_key))
  end

  def sign_in(user, password = PASSWORD_FOR_USER)
    post api_sign_in_path, params: { email: user.email, password: password }
    JSON.parse(response.body)
  end

  def logout(user)
    delete api_logout_path, headers: generate_jwt_token(user)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :request
  config.include SessionHelpers, type: :controller
  config.before(:suite) do
    PASSWORD_FOR_USER = "password123"
  end
end
