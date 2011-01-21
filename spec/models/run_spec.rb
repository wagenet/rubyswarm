require 'spec_helper'

describe "Run" do
  describe "creation" do
    it "should be valid" do
      build_run.should be_valid
    end

    it "should require job_id" do
      build_run(:job_id => nil).should_not be_valid
    end

    it "should require name" do
      build_run(:name => nil).should_not be_valid
    end

    it "should require url" do
      build_run(:url => nil).should_not be_valid
    end

    it "should require browsers" do
      build_run(:browsers => nil).should_not be_valid
    end

    it "should set up useragent_runs" do
      create_useragent(:popular => true)
      create_run(:browsers => 'popular').useragent_runs.should_not be_empty
    end
  end

  describe "run_started" do
    it "should set status to RUNNING" do
      run = create_run
      run.run_started
      run.status.should == Run::RUNNING
    end

    it "should call run_started on the job" do
      run = create_run
      run.job.should_receive(:run_started)
      run.run_started
    end

    it "should not run if done?" do
      run = create_run(:status => Run::DONE)
      run.run_started.should be_false
      run.job.should_not_receive(:run_started)
      run.status.should == Run::DONE
    end

    it "should not run if running?" do
      run = create_run(:status => Run::RUNNING)
      run.run_started.should be_false
      run.job.should_not_receive(:run_started)
      run.status.should == Run::RUNNING
    end
  end

  describe "run_completed" do
    describe "all useragent_runs are done" do
      before(:each) do
        @run = create_run(:status => Run::RUNNING)
        @run.useragent_runs.build(Factory.attributes_for(:useragent_run, :status => UseragentRun::DONE))
      end

      it "should set set status to DONE" do
        @run.run_completed
        @run.status.should == Run::DONE
      end

      it "should call run_completed on the job" do
        @run.job.should_receive(:run_completed)
        @run.run_completed
      end

    end

    it "should not run if unstarted" do
      run = create_run(:status => nil)
      run.job.should_not_receive(:run_completed)
      run.run_completed.should be_false
      run.status.should be_nil
    end

    it "should not run if DONE" do
      run = create_run(:status => Run::DONE)
      run.job.should_not_receive(:run_completed)
      run.run_completed.should be_false
      run.status.should == Run::DONE
    end

    it "should not run if not all useragent_runs are done" do
      run = create_run(:status => Run::RUNNING)
      run.useragent_runs.build(Factory.attributes_for(:useragent_run, :status => UseragentRun::RUNNING))
      run.job.should_not_receive(:run_completed)
      run.run_completed.should be_false
      run.status.should == Run::RUNNING
    end
  end

  describe "setup_useragent_runs" do
    it "should work normally" do
      useragent = create_useragent(:popular => true)
      run = build_run(:browsers => 'popular')
      run.send :setup_useragent_runs
      run.useragent_runs.size.should == 1
      run.useragent_runs.first.useragent.should == useragent
    end
  end
end
