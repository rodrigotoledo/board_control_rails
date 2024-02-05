require 'factory_bot_rails'
require 'simplecov'
require 'shoulda/matchers'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

SimpleCov.start 'rails' do
  add_filter 'vendor'
  add_filter 'storage'
  add_filter 'app/channels'
  add_filter 'app/helpers/application_helper.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

module SessionHelpers
  def sign_in(user, password = PASSWORD_FOR_USER)
    post sign_in_path, params: { email: user.email, password: password}
    JSON.parse(response.body)
  end

  def logout
    delete logout_path
  end
end


RSpec.configure do |config|
  config.include SessionHelpers, type: :request
  config.before(:suite) do
    PASSWORD_FOR_USER = 'password123'.freeze
  end
end
