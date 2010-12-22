class JobsController < ApplicationController
  load_and_authorize_resource
  before_filter :setup_client, :only => 'run'

  # GET /jobs
  # GET /jobs.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  def run
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job.user_id = current_user.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

  private

    def setup_client
      uastr = request.env['HTTP_USER_AGENT']
      @ua = Useragent.find_by_useragent(uastr)
      @client = Client.for_current(current_user, uastr, request.ip)
    end

end
