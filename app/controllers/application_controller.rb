class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :expire_clients

  private

    def expire_clients
      Client.expire
    end

end
