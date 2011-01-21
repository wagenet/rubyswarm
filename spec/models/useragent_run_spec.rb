require 'spec_helper'

describe UseragentRun do
  describe "creation" do
    it "should validate" do
      build_useragent_run.should be_valid
    end

    it "should require run_id" do
      build_useragent_run(:run_id => nil).should_not be_valid
    end

    it "should require useragent_id" do
      build_useragent_run(:useragent_id => nil).should_not be_valid
    end

    it "shoud require max" do
      build_useragent_run(:max => nil).should_not be_valid
    end
  end

  describe "scopes" do
    it "should find pending" do
      one = create_useragent_run(:runs => 0, :max => 1)
      two = create_useragent_run(:runs => 1, :max => 1)
      three = create_useragent_run(:runs => 2, :max => 1)
      UseragentRun.pending.should == [one]
    end
  end

  describe "status" do
    before(:each) do
      @running = create_useragent_run(:status => UseragentRun::RUNNING)
      @done = create_useragent_run(:status => UseragentRun::DONE)
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

  describe "start_run" do
    before(:each) do
      @client = create_client
    end

    it "should update runs and status" do
      uar = create_useragent_run(:runs => 0)
      uar.start_run(@client).should be_true
      uar.runs.should == 1
      uar.status.should == UseragentRun::RUNNING
    end

    it "should create client run" do
      cr_count = ClientRun.count
      uar = create_useragent_run
      uar.start_run(@client)

      ClientRun.count.should == cr_count + 1

      cr = ClientRun.last
      cr.client.should == @client
      cr.run.should == uar.run
      cr.status.should == ClientRun::RUNNING
    end

    it "should not allow unsaved records" do
      build_useragent_run.start_run(@client).should be_false
    end

    it "should notify run on first run" do
      uar = create_useragent_run
      uar.run.should_receive(:run_started)
      uar.start_run(@client)
    end

    it "should not notify run on second run" do
      uar = create_useragent_run(:runs => 1)
      uar.run.should_receive(:run_started)
      uar.start_run(@client)
    end
  end

  describe "run cancelled" do
    it "should decrements runs" do
      uar = create_useragent_run(:status => UseragentRun::RUNNING, :runs => 1)
      uar.run_cancelled.should be_true
      uar.runs.should == 0
    end

    it "should set back to running" do
      uar = create_useragent_run(:status => UseragentRun::DONE, :runs => 1)
      uar.run_cancelled.should be_true
      uar.runs.should == 0
      uar.should be_running
    end

    it "should not cancel new run" do
      uar = create_useragent_run(:status => 0, :runs => 1)
      uar.run_cancelled.should be_false
      uar.runs.should == 1
    end

    it "should not cancel if no runs" do
      uar = create_useragent_run(:status => UseragentRun::DONE, :runs => 0)
      uar.run_cancelled.should be_false
      uar.should be_done
    end
  end

  describe "run_completed" do
    it "should set status to DONE" do
      uar = create_useragent_run(:status => UseragentRun::RUNNING, :runs => 1, :max => 1)
      uar.run_completed
      uar.status.should == UseragentRun::DONE
    end

    it "should notify run of completion" do
      uar = create_useragent_run(:status => UseragentRun::RUNNING, :runs => 1, :max => 1)
      uar.run.should_receive(:run_completed)
      uar.run_completed
    end

    it "should not run unless runs is max" do
      uar = create_useragent_run(:status => UseragentRun::RUNNING, :runs => 1, :max => 2)
      uar.run_completed.should be_false
      uar.status.should == UseragentRun::RUNNING
    end

    it "should not run if no status" do
      uar = create_useragent_run(:runs => 1, :max => 1)
      uar.run_completed.should be_false
      uar.status.should be_nil
    end

    it "should not run if done" do
      uar = create_useragent_run(:status => UseragentRun::DONE, :runs => 1, :max => 1)
      uar.run_completed.should be_false
      uar.status.should == UseragentRun::DONE
    end
  end

end
