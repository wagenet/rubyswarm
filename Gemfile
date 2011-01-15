source 'http://rubygems.org'

gem 'rails', '3.0.3'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'jquery-rails', '>= 0.2.6'

gem 'devise'
gem 'cancan'

# For Proxy
gem 'strobe'

group :development do
  gem 'thin'
end

group :development, :test do
  gem 'autotest'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
  gem 'rspec-rails'
  gem 'capybara', '~> 0.4.0', :git => 'git://github.com/jnicklas/capybara.git', :require => false
end

group :test do
  gem 'factory_girl', :require => false
  gem 'simplecov', '~> 0.3', :require => false
end
