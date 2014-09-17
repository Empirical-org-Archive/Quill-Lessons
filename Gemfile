source 'https://rubygems.org'

ruby '2.1.2'

# CORE DEPS
gem 'rails', '~> 4.1.4'
gem 'puma'

# FOR ENV MGMT in test/dev. listed early to hijack 
# settings for other gems
gem 'dotenv-rails', groups: [:development, :test]

# DB/MODEL
gem 'pg'
gem 'ancestry'
gem 'taps'

# CACHING
gem 'redis-rails'

# USER AUTH, ETC
gem 'bcrypt-ruby'
# gem 'doorkeeper'
# gem 'cancancan', '~> 1.9'

# OTHERS
gem 'faraday_middleware'

# PARSING
gem 'parslet'
gem 'redcarpet'

# JS/APP/UI
gem 'turbolinks'
gem 'jquery-turbolinks'

# API
gem 'empirical-client', github: 'empirical-org/empirical-client' # path: '../client'

# UI HELPERS
gem 'sass-rails', github: 'rails/sass-rails'
gem 'bootstrap-sass', '~> 2.3.1.0' # app is locked to bootstrap 2.1.0
gem 'compass-rails'

gem 'coffee-rails'
gem 'jquery-rails'
gem 'backbone-on-rails'

gem 'slim-rails'
gem 'haml-rails'
gem 'haml_coffee_assets', github: 'netzpirat/haml_coffee_assets'

# ASSET/UI
gem 'kramdown'
gem 'therubyracer', require: false
gem 'uglifier'
gem 'kaminari'

# MIDDLEWARE
gem 'rack-cache', require: 'rack/cache'
gem 'rack-cors',  require: 'rack/cors'

# CMS (HONEY)
gem 'honey-cms', '0.4.7', path: 'vendor/gems/honey-cms-0.4.7'
gem 'honey-auth'#, path: '../honey-auth'

# DEPLOYMENT
gem 'slack-notifier' # event prompting
gem 'sentry-raven' # error tracking

group :production, :staging do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'mixpanel-ruby'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_21]
  gem 'foreman'
  gem "letter_opener"
end

group :test, :development do
  gem "quiet_assets"
  gem "pry-rails"
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem "awesome_print"
  gem "rspec-rails"
  gem 'fuubar', '~> 2.0.0.rc1'
  gem "timecop"
  gem "vcr"
  gem "factory_girl"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem 'byebug'
  gem 'guard'
  gem 'guard-rspec'
  # test runs for james; this triggers
  # a blink1(m) device to show red/green
  gem 'guard-shell'
  gem 'guard-blink1'
  gem 'terminal-notifier-guard'
end
