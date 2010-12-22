require 'spec_helper'

describe Client do
  describe "creation" do
    it "successfully validates a correct Client" do
      build_client.should be_valid
    end

    it "should require user_id" do
      build_client(:user_id => nil).should_not be_valid
    end

    it "should require useragent_id" do
      build_client(:useragent_id => nil).should_not be_valid
    end

    it "should require os" do
      build_client(:os => nil).should_not be_valid
    end

    it "should require useragentstr" do
      build_client(:useragentstr => nil).should_not be_valid
    end

    it "should require os" do
      build_client(:os => nil).should_not be_valid
    end
  end

  describe "scopes" do
    describe "timedout" do
      it "should find timedout client" do
        create_client(:active => true, :updated_at => Time.now - Client::TIMEOUT - 1)
        Client.timedout.count.should eql(1)
      end

      it "should not find inactive client" do
        create_client(:active => false, :updated_at => Time.now - Client::TIMEOUT - 1)
        Client.timedout.count.should be(0)
      end

      it "should not find recent client" do
        create_client(:active => true, :updated_at => Time.now)
        Client.timedout.count.should be(0)
      end
    end
  end

  describe "class methods" do
    describe "for_current" do
      it "should return existing and activate" do
        uadata = USERAGENTS[:chrome]
        useragent = create_useragent(:engine => uadata[:engine], :version => '.*')
        client = create_client(:active => false, :useragent => useragent)
        found = Client.for_current(client.user, uadata[:str], client.ip)
        found.should == client
        found.should be_active
      end

      it "should create if no existing" do
        uadata = USERAGENTS[:chrome]
        create_useragent(:engine => uadata[:engine], :version => '.*')
        client = Client.for_current(current_user, uadata[:str], '192.168.1.1')
        client.should be_valid
        client.should_not be_new_record
        client.should be_active
      end
    end

    describe "expire" do
      it "should timeout expired clients" do
        client = create_client(:active => true, :updated_at => Time.now - Client::TIMEOUT - 1)
        Client.expire
        client.reload
        client.should_not be_active
      end
    end

    describe "timeout" do
      before(:each) do
        @client = create_client(:active => true, :updated_at => Time.now - Client::TIMEOUT - 1)
      end

      it "should deactivate" do
        @client.timeout
        @client.should_not be_active
      end

      it "should destroy running client_runs" do
        create_client_run(:client => @client, :status => ClientRun::RUNNING)
        @client.client_runs.count == 1
        @client.timeout
        @client.client_runs.count == 0
      end

      it "should not destroy inactive and completed client_runs" do
        create_client_run(:client => @client)
        create_client_run(:client => @client, :status => ClientRun::DONE)
        @client.client_runs.count == 2
        @client.timeout
        @client.client_runs.count == 0
      end

      it "should decrement UseragentRuns count"
    end

    it "should not serialize ip" do
      client = build_client
      client.to_xml.should_not include(client.ip)
      client.to_json.should_not include(client.ip)
    end
  end
end

