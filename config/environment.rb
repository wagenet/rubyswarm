# Load the rails application
require File.expand_path('../application', __FILE__)
require File.join(Rails.root, 'lib', 'rack', 'github_proxy')

RubySwarm::Application.configure do
  config.middleware.use GithubProxy
end

# Initialize the rails application
RubySwarm::Application.initialize!
