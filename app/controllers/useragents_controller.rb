class UseragentsController < ApplicationController

  before_filter :authenticate_user!, :except => ['index', 'show']

  # GET /useragents
  # GET /useragents.xml
  def index
    @useragents = Useragent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @useragents }
    end
  end

  # GET /useragents/1
  # GET /useragents/1.xml
  def show
    @useragent = Useragent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @useragent }
    end
  end

  # GET /useragents/new
  # GET /useragents/new.xml
  def new
    @useragent = Useragent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @useragent }
    end
  end

  # GET /useragents/1/edit
  def edit
    @useragent = Useragent.find(params[:id])
  end

  # POST /useragents
  # POST /useragents.xml
  def create
    @useragent = Useragent.new(params[:useragent])

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
    @useragent = Useragent.find(params[:id])

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
    @useragent = Useragent.find(params[:id])
    @useragent.destroy

    respond_to do |format|
      format.html { redirect_to(useragents_url) }
      format.xml  { head :ok }
    end
  end
end

