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
