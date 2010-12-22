require 'spec_helper'

describe ClientRun do
  describe "creation" do
    it "should be valid" do
      build_client_run.should be_valid
    end

    it "should require run_id" do
      build_client_run(:run_id => nil).should_not be_valid
    end

    it "should require client_id" do
      build_client_run(:client_id => nil).should_not be_valid
    end
  end

  describe "scopes" do
    before(:each) do
      @running = create_client_run(:status => ClientRun::RUNNING)
      @done = create_client_run(:status => ClientRun::DONE)
    end

    it "should find running" do
      ClientRun.running.should == [@running]
    end

    it "should find done" do
      ClientRun.done.should == [@done]
    end
  end

  describe "status" do
    before(:each) do
      @running = create_client_run(:status => ClientRun::RUNNING)
      @done = create_client_run(:status => ClientRun::DONE)
    end

    it "should tell if running" do
      @running.running?.should be_true
      @done.running?.should be_false
    end

    it "should tell if done" do
      @running.done?.should be_false
      @done.done?.should be_true
    end
  end
end
