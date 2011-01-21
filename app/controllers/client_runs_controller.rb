class ClientRunsController < ApplicationController
  load_and_authorize_resource

  def show
    if @client_run.results
      send_data @client_run.results, :type => 'text/html', :disposition => 'inline'
    else
      render :text => 'No Saved Results', :layout => false
    end
  end

end
