class RunsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_client
  before_filter :check_xhr

  def get
    @useragent_run = @ua && UseragentRun.pending.where(:useragent_id => @ua.id).first

    if @useragent_run && can?(:run, @useragent_run)
      @useragent_run.start_run(@client)
      render :json => @useragent_run.run
    else
      render :json => { :message => "Nothing to Run" }
    end
  end

  # TODO: I'm not entirely sure about the way this method actually updates client_run not run
  def update
    # FIXME: Can we clean this up?
    @useragent_run = @ua && UseragentRun.where(:useragent_id => @ua.id, :run_id => params[:id]).first
    raise ActiveRecord::RecordNotFound unless @useragent_run
    authorize! :run, @useragent_run

    @client_run = ClientRun.where(:run_id => @useragent_run.run_id, :client_id => @client.id).first
    raise ActiveRecord::RecordNotFound unless @client_run

    respond_to do |format|
      #TODO: Should we check permissions on the client_run?
      if @client_run.update_attributes(params[:run])
        format.json { head :ok }
      else
        format.json { render :json => @client_run.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

    def check_xhr
      #FIXME: User proper status code
      render :text => "Not allowed" and return false unless request.xhr?
    end

end
