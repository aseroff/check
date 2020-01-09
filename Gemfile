# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.4'

gem 'puma'
gem 'rails'
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

gem 'devise'
gem 'file_validators'
gem 'friendly_id'
gem 'jquery-rails'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'will_paginate'
# gem 'sendgrid-ruby'
gem 'coffee-rails'
gem 'jbuilder'
gem 'koala'
gem 'twitter'
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

group :production, :staging do
  gem 'pg'
end

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'reek', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubycritic', require: false
  gem 'selenium-webdriver'
  gem 'yard'
  # Generates an ERD based on the app's models
  gem 'mysql2'
  gem 'rails-erd'
end

group :development do
  gem 'listen'
  gem 'rb-readline'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
