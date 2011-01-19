require 'spec_helper'

describe "Github Proxy" do
  include Rack::Test::Methods

  def app
    Rack::Builder.app do
      use GithubProxy
      lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'OK'] }
    end
  end

  it "should pass-through non-matching calls" do
    get "/"
    last_response.body.should == 'OK'
  end
end
