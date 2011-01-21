require 'spec_helper'

describe RunsController do
  describe "normal user" do
    before(:each) do
      sign_in current_user

      @uadata = USERAGENTS[:chrome]
      request.user_agent = @uadata[:str]
    end

    describe "get" do
      it "should require XHR" do
        get 'get'

        response.should be_success
        response.body.should == "Not allowed"
      end

      it "should find pending run" do
        useragent = create_useragent(:engine => @uadata[:engine], :version => @uadata[:version])
        useragent_run = create_useragent_run(:useragent => useragent)

        xhr :get, 'get'

        response.should be_success
        response.body.should == useragent_run.run.reload.to_json
      end

      it "should notify when no runs" do
        xhr :get, 'get'

        response.should be_success
        response.body.should == { :message => "Nothing to Run" }.to_json
      end
    end

    describe "update" do
      before(:each) do
        @useragent = create_useragent(:engine => @uadata[:engine], :version => @uadata[:version])
        @client = create_client(:useragent => @useragent, :user => current_user, :ip => '0.0.0.0')
        @useragent_run = create_useragent_run(:useragent => @useragent)
        @client_run = create_client_run(:run => @useragent_run.run, :client => @client)
      end

      it "should require XHR" do
        put 'update', :id => @useragent_run.id
        response.body.should == "Not allowed"
      end

      it "should return NotFound without ClientRun" do
        @client_run.destroy
        lambda{ xhr :put, 'update', :id => @useragent_run.run_id }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should update with valid attributes" do
        xhr :put, 'update', :id => @useragent_run.run_id, :run => { :fail => 0, :error => 0, :total => 5 }
        @client_run.reload
        @client_run.fail.should == 0
        @client_run.error.should == 0
        @client_run.total.should == 5
        @client_run.should be_done
      end

      it "should handle invalid attributes" do
        xhr :put, 'update', :id => @useragent_run.run_id, :run => { :total => -1 }
        response.should_not be_success
      end
    end
  end

  describe "no user" do
    it "should not be able to get run"
    it "should not be able to update run"
  end
end
