source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"
gem "rails", github: "rails/rails", branch: "main"

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
gem "devise"
gem "aws-sdk-s3", "~> 1.132"
gem "recaptcha", "~> 5.15"
gem "chartkick"
gem "rqrcode", "~> 2.2"
gem "solid_queue"
gem "mission_control-jobs", github: "rails/mission_control-jobs", branch: "main"
gem "rollbar"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry", "~> 0.14.2"
  gem "brakeman", require: false
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
