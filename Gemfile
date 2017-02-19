# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster.
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'guard-rubocop'
  gem 'jbuilder', '~> 2.5'
end

group :development do
  # Access an IRB console on exception pages or by
  # using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec', require: false
  gem 'rubocop-rspec', '1.10.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# RSpec!
gem 'rspec-rails', '3.5.2'

# Laziness
gem 'gemrat', '0.4.6'

# Database models
gem 'kagu', git: 'git://github.com/birdfeed/kagu.git'

# Authentication system (if we want ACLs we can use CanCan but it's old as shit)
gem 'devise', '4.2.0'

# API
gem 'grape', '0.19.1'

# Entity system with Grape, HAL plugins
gem 'roar', '1.1.0'
gem 'grape-roar', '0.4.0'

# The best thing ever
gem 'pry', '0.10.4'
gem 'pry-rails', '0.3.5'

# Factories
gem 'factory_girl', '4.8.0'
gem 'factory_girl_rails', '4.8.0'

# Fancy ass errors
gem 'better_errors', '2.1.1'

# Generate fixture strings, numbers, etc.
gem 'faker', '1.7.3'