source 'http://rubygems.org'

gem 'rails', '3.0.3'
# gem 'rails', :git => 'git://github.com/rails/rails.git' # edge rails
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'unicorn'
gem 'bundler'
gem 'ruby-debug19'

# Deploy with Capistrano
# gem 'capistrano'

gem 'nokogiri'
gem 'w3c_validators'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem "rspec"
  gem "rspec-rails"
  gem "remarkable_activemodel", '4.0.0.alpha4'
  gem 'capybara'
  gem 'forgery', '~> 0.3.7'
  gem 'fakeweb', '~> 1.3.0'
  # gem 'launchy', '~> 0.4.0'
  gem "awesome_print", :require => "ap"
end
