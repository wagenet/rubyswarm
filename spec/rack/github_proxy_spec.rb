require 'spec_helper'
require 'rack/lobster'

describe "Github Proxy" do
  include Rack::Test::Methods

  def app
    Rack::Builder.app do
      use GithubProxy
      run Rack::Lobster.new
    end
  end

  it "should pass-through non-matching calls" do
    get "/"
    last_response.body.should =~ /Lobstericious/
  end
end
