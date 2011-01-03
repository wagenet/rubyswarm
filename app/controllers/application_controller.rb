class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :expire_clients

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private

    def expire_clients
      Client.expire
      ClientRun.expire
    end

    def setup_client
      uastr = request.user_agent
      @ua = Useragent.find_by_useragent(uastr)
      @client = Client.for_current(current_user, uastr, request.ip)
    end

end
