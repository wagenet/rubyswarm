class ClientsController < ApplicationController
  load_and_authorize_resource

  # GET /clients
  # GET /clients.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

end
