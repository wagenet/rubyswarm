# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.at_exit do
  # TODO: See if we can get this to run only when we're running all tests, not just some
  res = SimpleCov.result
  puts "Coverage: #{res.covered_percent.round(2)}%"
  res.format!
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'cancan/matchers'
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include SpecHelpers
  config.include DeviseIntegrationHelpers # Devise::TestHelpers will overwrite some of this, which is expected
  config.include Devise::TestHelpers, :type => :controller
  config.include Rails.application.routes.url_helpers
  config.mock_with :rspec
  config.use_transactional_fixtures = true
end
