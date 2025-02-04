source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Rails core gems
gem "rails", "~> 7.1.3"
gem "sprockets-rails"
gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"

# Asset pipeline and frontend
gem "tailwindcss-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "jbuilder"

# Authentication and Authorization
gem "devise"
gem "pundit"

# File upload and processing
gem "image_processing", "~> 1.2"

# Background processing
gem "sidekiq"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "spring"
  gem "listen", "~> 3.8"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
