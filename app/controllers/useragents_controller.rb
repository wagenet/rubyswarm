class UseragentsController < ApplicationController
  load_and_authorize_resource

  # GET /useragents
  # GET /useragents.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @useragents }
    end
  end

  # GET /useragents/1
  # GET /useragents/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @useragent }
    end
  end

  # GET /useragents/new
  # GET /useragents/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @useragent }
    end
  end

  # GET /useragents/1/edit
  def edit
  end

  # POST /useragents
  # POST /useragents.xml
  def create
    respond_to do |format|
      if @useragent.save
        format.html { redirect_to(@useragent, :notice => 'Useragent was successfully created.') }
        format.xml  { render :xml => @useragent, :status => :created, :location => @useragent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @useragent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /useragents/1
  # PUT /useragents/1.xml
  def update
    respond_to do |format|
      if @useragent.update_attributes(params[:useragent])
        format.html { redirect_to(@useragent, :notice => 'Useragent was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @useragent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /useragents/1
  # DELETE /useragents/1.xml
  def destroy
    @useragent.destroy

    respond_to do |format|
      format.html { redirect_to(useragents_url) }
      format.xml  { head :ok }
    end
  end
end

