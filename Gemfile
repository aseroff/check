# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.5'

gem 'pg'
gem 'puma'
gem 'rails'
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'devise'
gem 'file_validators'
gem 'friendly_id'
gem 'jquery-rails'
gem 'will_paginate'
# gem 'sendgrid-ruby'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'koala'
gem 'twitter', '>= 5.0.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'carrierwave', '~> 1'
gem 'figaro'
gem 'fog-aws'
gem 'httparty'
gem 'local_time'
gem 'mini_magick'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'social-share-button'

gem 'newrelic_rpm'

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13.0'
  gem 'reek', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'selenium-webdriver'
  gem 'yard'
  # Generates an ERD based on the app's models
  gem 'rails-erd'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
