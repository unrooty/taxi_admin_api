# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'
gem 'rails', '~> 5.2.3'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bcrypt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'dry-matcher'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-entity'
gem 'grape-swagger-rails'
gem 'jwt'
gem 'pundit'
gem 'rails-i18n'
gem 'rubocop', require: false
gem 'sequel-devise'
gem 'sequel-devise-generators'
gem 'sequel-rails'
# FIX: TRAILBLAZER CAN NOT BE UPDATED BECAUSE OF CHANGES IN DSL. IT PROBABLY WIL BE REPLACED WITH GEM FLOW

gem 'reform-rails', '~> 0.1'
gem 'trailblazer-rails', '~> 2.1.7'
gem 'trailblazer', '= 2.1.0.rc1'
gem 'trailblazer-macro', '= 2.1.0rc1'
gem 'trailblazer-activity', '= 0.7.1'
gem 'trailblazer-operation', '= 0.4.1'

##########################################################################################################
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'airborne'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner'
  gem 'rspec_sequel_matchers'
  gem 'simplecov', require: false, group: :test
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# gem 'common_lib', git: 'https://github.com/unrooty/common_lib.git', require: false
