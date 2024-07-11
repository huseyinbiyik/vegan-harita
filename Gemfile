source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem "rails", "~> 7.1.2"

# Default gems
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"

# Authentication
gem "devise"

# Map
gem "geocoder", "~> 1.8"

# Charts
gem "chartkick"

# QR code generation
gem "rqrcode", "~> 2.2"

# Job processing
gem "solid_queue", "~> 0.3.1"
gem "mission_control-jobs", "~> 0.2.1"

# Error tracking
gem "stackprof"
gem "sentry-ruby"
gem "sentry-rails"

gem "aws-sdk-s3", "~> 1.132"
gem "recaptcha", "~> 5.15"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry", "~> 0.14.2"
  gem "brakeman", "~> 6.1"
end

group :development do
  gem "rubocop-rails-omakase", require: false
  gem "dockerfile-rails", ">= 1.0.0"
  gem "erb-formatter"
  gem "letter_opener"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
