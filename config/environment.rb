# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('vendor/strobe/middleware/proxy', Rails.root)

RubySwarm::Application.configure do
  config.middleware.use Strobe::Middleware::Proxy
end

# Initialize the rails application
RubySwarm::Application.initialize!
