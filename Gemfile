source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use Dart SASS [https://github.com/rails/dartsass-rails]
gem "dartsass-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache and Active Job
gem "solid_cache"
gem "solid_queue"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Http gem with a chainable interface, alternative to Net/HTTP or HTTParty
gem 'http'

# JSON views for models
gem 'jbuilder'

# Memory key/value store
gem 'redis'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # RSpec testing framework - alturnative to minitest
  gem "rspec-rails"

  # Time manipulation in tests
  gem "timecop"

  # Fixture replacement framework: https://github.com/thoughtbot/factory_bot_rails
  gem 'factory_bot_rails'

  # Shows HTTP request details in the log files
  gem 'httplog', require: ENV['HTTPLOG'] == 'true'
end

group :development do
  gem 'yard', require: false # Documentation parser
end

group :test do
  # For API testing without making actual requests
  gem 'webmock'

  # Records HTTP requests for later repeat use with webmock
  gem 'vcr'
end
