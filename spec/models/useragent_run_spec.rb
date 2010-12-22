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

  describe "start_run" do
    it "should update runs and status" do
      uar = create_useragent_run(:runs => 0)
      uar.start_run.should be_true
      uar.runs.should == 1
      uar.status.should == UseragentRun::IN_PROGRESS
    end

    it "should not allow unsaved records" do
      build_useragent_run.start_run.should be_false
    end
  end
end
