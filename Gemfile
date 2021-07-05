source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.5'

# A
gem 'aws-sdk', '~> 3'

# B
gem 'bootstrap-datepicker-rails'
# gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap', '~> 5.0.1'
gem 'browser'

# C
gem 'cancancan'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'client_side_validations'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# D
gem 'dalli'
gem 'delayed_job_active_record'
gem 'detect_timezone_rails'
gem 'devise', '4.4.3'

# E
gem 'email_verifier'

# F
gem 'figaro'
gem 'filterrific', '~> 5.0'
gem 'friendly_id', '~> 5.2.4'
# G
gem 'geocoder', '1.4.5'

# H
gem 'haml'
gem 'httparty'

# I
gem 'iconv', '~> 1.0.3'

# J
gem 'jbuilder', '~> 2.5'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# K
gem 'kgio'

# L

# M
gem 'memcachier'
gem 'momentjs-rails'

# N

# O
gem 'oj' # Oj for JSON serialization
gem 'omniauth', '1.9.1'
gem 'omniauth-google-oauth2'

# P
gem 'paperclip', '~> 5.0.0'
gem 'pagy' # pagination
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search'
gem 'puma', '~> 3.11'

# Q

# R
gem 'ratyrate', github: 'wazery/ratyrate'
gem 'rolify'

# S
gem 'sass-rails', '~> 5.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'social-share-button'
gem 'stripe'
gem 'stripe_event'

# T
gem 'thumbs_up'

# U
gem 'underscore-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# V
gem 'valid_url'
gem 'validates_timeliness', '~> 5.0.0.alpha3'

# W
# gem 'webpacker'
gem 'wicked'
gem 'wicked_pdf', '1.1.0'
# gem 'will_paginate-bootstrap4'
gem 'wkhtmltopdf-binary' #, '0.12.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'foreman'
  gem 'letter_opener'
  gem 'lol_dba'
  gem 'meta_request'
  gem 'pry'
  gem 'rack-mini-profiler', require: false
  gem 'rubocop', '~> 0.75.1', require: false
  gem 'rubycritic', require: false
  # Spring speeds up development by keeping your application running in the background. 
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem "skylight"
  gem 'whenever'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'heroku-deflater', git: 'https://github.com/romanbsd/heroku-deflater.git' # Enable gzip compression on heroku, but don't compress images.
  gem 'rails_12factor'
  gem 'wkhtmltopdf-heroku', '2.12.4.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
