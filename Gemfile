source "https://rubygems.org"

# Core Rails
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.2"
gem "pg"
gem "sqlite3", ">= 2.1"

gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

gem "image_processing", ">= 1.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Background processing and caching
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Performance
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development do
  gem "web-console"
end

group :development, :test do
  gem "pry"
  gem "active_record_query_trace"
  gem "bullet"
  gem "bundler-audit"
  gem "faker"
  gem "guard-rspec", require: false
  gem "letter_opener"
  gem "rails-controller-testing"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "simplecov", require: false

  # Security
  gem "brakeman", require: false

  # Code quality
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
end

group :test do
  gem "database_cleaner-active_record"
  gem "rspec-json_expectations"
  gem "shoulda-matchers"
end

gem "email_validator"
gem "jwt"
gem "rack-cors", "~> 2.0"

gem "kaminari", "~> 1.2"

gem "ransack", "~> 4.3"

gem "tailwindcss-ruby", "~> 4.1"

gem "tailwindcss-rails", "~> 4.2"
