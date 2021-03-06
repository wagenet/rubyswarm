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
    describe "status" do
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

    describe "timedout" do
      it "should find timedout client_run" do
        create_client_run(:status => ClientRun::RUNNING, :updated_at => Time.now - ClientRun::TIMEOUT - 1)
        ClientRun.timedout.count.should eql(1)
      end

      it "should not find completed client_run" do
        create_client_run(:status => ClientRun::DONE, :updated_at => Time.now - ClientRun::TIMEOUT - 1)
        ClientRun.timedout.count.should be(0)
      end

      it "should not find failed client_run" do
        create_client_run(:status => ClientRun::FAILED, :updated_at => Time.now - ClientRun::TIMEOUT - 1)
        ClientRun.timedout.count.should be(0)
      end


      it "should not find recent client" do
        create_client_run(:status => ClientRun::RUNNING, :updated_at => Time.now)
        ClientRun.timedout.count.should be(0)
      end
    end
  end

  describe "class methods" do
    describe "expire" do
      it "should timeout expired client_runs" do
        client_run = create_client_run(:status => ClientRun::RUNNING, :updated_at => Time.now - ClientRun::TIMEOUT - 1)
        ClientRun.expire
        client_run.reload
        client_run.should be_failed
      end
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

  describe "useragent_run" do
    before(:each) do
      @uar = create_useragent_run
      @client = create_client(:useragent => @uar.useragent)
      @cr = create_client_run(:client => @client, :run => @uar.run)
    end

    it "should find" do
      @cr.useragent_run.should == @uar
    end

    it "should cache" do
      @cr.useragent_run # Cache it
      @uar.destroy
      @cr.useragent_run.should == @uar
    end
  end

  describe "timeout" do
    before(:each) do
      @client = create_client
      @useragent_run = create_useragent_run(:useragent => @client.useragent, :runs => 1, :status => UseragentRun::RUNNING)
      @client_run = create_client_run(:client => @client, :run => @useragent_run.run,
                                      :status => ClientRun::RUNNING, :updated_at => Time.now - ClientRun::TIMEOUT - 1)
    end

    it "should fail" do
      @client_run.timeout
      @client_run.should be_failed
    end

    it "should cancel useragent_run" do
      @client_run.timeout
      @useragent_run.reload.runs.should == 0
    end

    it "should not run if done" do
      @client_run.status = ClientRun::DONE
      @client_run.timeout
      @client_run.should be_done
    end

    it "should not run if failed" do
      @client_run.status = ClientRun::FAILED
      @client_run.timeout
      @client_run.should be_failed
    end
  end

  describe "save results" do
    before(:each) do
      @client_run = build_client_run(:status => ClientRun::RUNNING)
    end

    it "should save without errors" do
      @client_run.save_results(:fail => 0, :error => 0, :total => 5).should be_true
      @client_run.fail.should == 0
      @client_run.error.should == 0
      @client_run.total.should == 5
      @client_run.should be_done
    end

    it "should save with errors" do
      @client_run.save_results(:fail => 1, :error => 1, :total => 5).should be_true
      @client_run.fail.should == 1
      @client_run.error.should == 1
      @client_run.total.should == 5
      @client_run.should be_failed
    end

    it "should notify the useragent_run that the run completed" do
      create_useragent_run(:useragent => @client_run.client.useragent, :run => @client_run.run)
      # I normally discourage stubbing but I think it's ok in this case, all I want to check is that it notifies
      @client_run.useragent_run.should_receive(:run_completed)
      @client_run.save_results(:fail => 0, :error => 0, :total => 5).should be_true
    end
  end

  describe "notify cancelled" do
    before(:each) do
      @client = create_client
      @uar = create_useragent_run(:useragent => @client.useragent, :runs => 1, :status => UseragentRun::RUNNING)
      @cr = create_client_run(:client => @client, :run => @uar.run, :status => ClientRun::RUNNING)
    end

    it "should cancel uar" do
      @cr.send(:notify_cancelled)
      @uar.reload.runs.should == 0
    end

    it "should not notify when not running or done" do
      @cr.status = 0
      @cr.send(:notify_cancelled)
      @uar.reload.runs.should == 1
    end

    it "should run before destroy" do
      @cr.destroy
      @uar.reload.runs.should == 0
    end
  end
end
