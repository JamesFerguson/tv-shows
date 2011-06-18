source 'http://rubygems.org'

gem 'rails', '3.0.3'
# gem 'rails', :git => 'git://github.com/rails/rails.git' # edge rails
gem 'mysql2', '~> 0.2.1'
gem 'bundler'

# Deploy with Capistrano
# gem 'capistrano'

gem 'nokogiri'
gem 'w3c_validators'
gem 'heroku'
gem 'friendly_id'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'unicorn'
  gem 'ruby-debug19'

  gem "rspec"
  gem "rspec-rails"
  gem "remarkable_activemodel"

  gem 'capybara'

  gem 'machinist'
  gem 'forgery'

  gem 'fakeweb'

  # gem 'launchy'
  gem "awesome_print", :require => "ap"
end
