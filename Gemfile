source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.7'

#A
#gem 'activesupport-json_encoder'
gem 'american_date'
gem 'aws-sdk', '~> 2.3'
gem 'axlsx_rails'

#B
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'browser'
gem 'buttercms-rails'

#C
gem 'client_side_validations'
gem 'cancancan'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
gem 'counter_cache_with_conditions'

#D
gem 'dalli'
gem 'delayed_job_active_record'
gem 'dynamic_form'
gem 'devise', '4.4.3'

#E
gem 'email_verifier'

#F
gem "figaro"
gem 'filterrific', '~> 5.0'
gem "font-awesome-rails"
gem 'friendly_id', '~> 5.2.4'
#G
gem 'geocoder', '1.4.5'

#H
gem 'haml', git: 'https://github.com/haml/haml'
gem 'httparty'

#I
gem "iconv", "~> 1.0.3"

#J
gem 'jbuilder', '~> 2.0'
gem 'jquery-fileupload-rails', github: 'Springest/jquery-fileupload-rails'
gem 'jquery-placeholder-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'

#K
gem 'kgio'

#L

#M
gem 'memcachier'
gem 'momentjs-rails'
gem 'multi_fetch_fragments'

#N

#O
gem 'oj', '~> 2.16.1'  #Oj for JSON serialization
gem 'omniauth'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"

#P
gem "paperclip", "~> 5.0.0"
gem 'pg', '~> 0.21.0'
gem 'pg_search'
gem 'puma'

#Q

#R
gem 'ratyrate', github: 'wazery/ratyrate'
gem "recaptcha", require: "recaptcha/rails"
gem 'roo'
gem "rolify"
gem 'rollbar'
gem 'rack-cache'

#S
gem 'sass-rails', '~> 5.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#gem 'simple-line-icons-rails'
gem 'sitemap_generator'
gem 'social-share-button'
gem 'stripe'

#T
gem 'thumbs_up'
#gem 'turbolinks', '~> 5.2.0'

#U
gem 'underscore-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

#V
gem 'valid_url'
gem 'validates_timeliness', '~> 5.0.0.alpha3'

#W
gem 'wicked'
gem 'wicked_pdf'
gem 'will_paginate-bootstrap'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'sqlite3'
  gem 'pry'
  gem "better_errors"
  gem 'binding_of_caller'
  gem "letter_opener"
  gem 'rack-mini-profiler', require: false
  gem 'bullet'
  gem 'annotate'
  gem 'meta_request'
  gem 'rails-footnotes', '~> 4.0'
  gem 'lol_dba'
  gem 'rubocop', '~> 0.75.1', require: false
  gem "rubycritic", require: false
end

group :production do
  gem 'rails_12factor'
  gem 'heroku-deflater', git: "https://github.com/romanbsd/heroku-deflater.git" #Enable gzip compression on heroku, but don't compress images.
  gem 'wkhtmltopdf-binary' #, '0.12.4'
  gem 'wkhtmltopdf-heroku'
end

ruby "2.4.0"
