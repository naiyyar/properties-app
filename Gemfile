source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.7'

# A
# gem 'activesupport-json_encoder'
gem 'american_date'
gem 'aws-sdk', '~> 3'
gem 'axlsx_rails' # has renamed to caxlsx_rails

# B
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-sass', '~> 3.3.6'
# Not compatible with jquery 3
# gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'browser'
gem 'buttercms-rails'

# C
gem 'cancancan'
gem 'client_side_validations'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
gem 'counter_cache_with_conditions'

# D
gem 'dalli'
gem 'delayed_job_active_record'
gem 'detect_timezone_rails'
gem 'devise', '4.4.3'
gem 'dynamic_form'

# E
gem 'email_verifier'

# F
gem 'figaro'
gem 'filterrific', '~> 5.0'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.2.4'
# G
gem 'geocoder', '1.4.5'

# H
gem 'haml', git: 'https://github.com/haml/haml'
gem 'httparty'

# I
gem 'iconv', '~> 1.0.3'

# J
gem 'jbuilder', '~> 2.0'
gem 'jquery-fileupload-rails', github: 'Springest/jquery-fileupload-rails'
gem 'jquery-placeholder-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# K
gem 'kgio'

# L

# M
gem 'memcachier'
gem 'momentjs-rails'
gem 'multi_fetch_fragments'

# N

# O
gem 'oj', '~> 2.16.1' # Oj for JSON serialization
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# P
gem 'paperclip', '~> 5.0.0'
gem 'pg', '~> 0.21.0'
gem 'pg_search'
gem 'puma'

# Q

# R
gem 'rack-cache'
gem 'ratyrate', github: 'wazery/ratyrate'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'rolify'
gem 'roo'
gem 'rollbar'

# S
gem 'sass-rails', '~> 5.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# gem 'simple-line-icons-rails'
gem 'sitemap_generator'
gem 'social-share-button'
gem 'stripe'
gem 'stripe_event'

# T
gem 'thumbs_up'
# gem 'turbolinks', '~> 5.2.0'

# U
gem 'underscore-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# V
gem 'valid_url'
gem 'validates_timeliness', '~> 5.0.0.alpha3'

# W
gem 'wicked'
gem 'wicked_pdf', '1.1.0'
gem 'will_paginate-bootstrap'
gem 'wkhtmltopdf-binary', '0.12.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to get a debugger console
  gem 'byebug'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman'
  gem 'bullet'
  gem 'foreman'
  gem 'letter_opener'
  gem 'lol_dba'
  gem 'meta_request'
  gem 'pry'
  gem 'rack-mini-profiler', require: false
  gem 'rails-footnotes', '~> 4.0'
  gem 'rubocop', '~> 0.75.1', require: false
  gem 'rubycritic', require: false
  # Spring speeds up development by keeping your application running in the background. 
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'whenever'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'heroku-deflater', git: 'https://github.com/romanbsd/heroku-deflater.git' # Enable gzip compression on heroku, but don't compress images.
  gem 'rails_12factor'
  gem 'wkhtmltopdf-heroku', '2.12.4.0'
end

ruby '2.4.0'
