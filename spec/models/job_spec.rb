require 'spec_helper'

describe Job do
  describe "creation" do
    it "should be valid" do
      build_job.should be_valid
    end

    it "should require user_id" do
      build_job(:user_id => nil).should_not be_valid
    end

    it "should require name" do
      build_job(:name => nil).should_not be_valid
    end

    it "should require browsers" do
      build_job(:browsers => nil).should_not be_valid
    end

    it "should require suites" do
      build_job(:suites => nil).should_not be_valid
    end

    it "should setup runs" do
      j = create_job
      j.runs.should_not be_empty
    end
  end

  describe "attribute protection" do
    it "should allow assignment of name, browsers, suites" do
      j = Job.new(:name => "Name", :browsers => "popular", :suites => "One: google.com")
      j.name.should == "Name"
      j.browsers.should == "popular"
      j.suites.should == { 'One' => 'google.com' }
    end

    it "should not allow assignment of user" do
      j = Job.new(:user => current_user)
      j.user.should be_nil
    end
  end

  describe "browser assignment" do
    describe "array" do
      it "should create string" do
        j = Job.new(:browsers => ['popular', 'beta'])
        j.browsers = 'popularbeta'
      end

      it "should order the list" do
        j = Job.new(:browsers => Useragent::BROWSER_TYPES.reverse)
        j.browsers.should == Useragent::BROWSER_TYPES.join
      end

      it "should reject items not in the list" do
        j = Job.new(:browsers => ['popular', 'other'])
        j.browsers.should == 'popular'
      end
    end

    describe "string" do
      it "should pass through" do
        j = Job.new(:browsers => 'popularbeta')
        j.browsers = 'popularbeta'
      end

      it "should order the list" do
        j = Job.new(:browsers => Useragent::BROWSER_TYPES.reverse.join)
        j.browsers.should == Useragent::BROWSER_TYPES.join
      end

      it "should reject items not in the list" do
        j = Job.new(:browsers => 'popularother')
        j.browsers.should == 'popular'
      end
    end

    it "should not handle other types" do
      j = Job.new(:browsers => 1)
      j.browsers.should be_nil
    end
  end

  describe "suite assignment" do
    describe "string" do
      it "should parse valid" do
        j = Job.new(:suites => "One: http://google.com\nTwo: http://yahoo.com")
        j.suites.should == { 'One' => 'http://google.com', 'Two' => 'http://yahoo.com' }
      end

      it "should not parse invalid" do
        j = Job.new(:suites => "Suite!")
        j.suites.should be_blank
      end
    end

    it "should pass through hash" do
      suites = { 'One' => 'http://google.com', 'Two' => 'http://yahoo.com' }
      j = Job.new(:suites => suites)
      j.suites.should == suites
    end

    it "should not handle other types" do
      j = Job.new(:suites => 1)
      j.suites.should be_nil
    end
  end

  describe "run_started" do
    it "should update status to RUNNING" do
      job = create_job
      job.run_started
      job.status.should == Job::RUNNING
    end

    it "should not update if done?" do
      job = create_job(:status => Job::DONE)
      job.run_started.should be_false
      job.status.should == Job::DONE
    end

    it "should not update if running?" do
      job = create_job(:status => Job::RUNNING)
      job.run_started.should be_false
    end
  end

  describe "run_completed" do
    it "should update status to DONE" do
      job = create_job(:status => Job::RUNNING)
      job.run_completed
      job.status.should == Job::DONE
    end

    it "should not update if new" do
      job = create_job
      job.run_completed.should be_false
      job.status.should be_nil
    end

    it "should not update if done?" do
      job = create_job(:status => Job::DONE)
      job.run_completed.should be_false
    end
  end

  it "should setup runs" do
    j = build_job(:browsers => 'popular', :suites => { 'One' => 'http://google.com', 'Two' => 'http://yahoo.com' })
    j.send :setup_runs
    j.runs[0].attributes.slice('name', 'url', 'browsers').should == { 'name' => 'One', 'url' => 'http://google.com', 'browsers' => 'popular' }
    j.runs[1].attributes.slice('name', 'url', 'browsers').should == { 'name' => 'Two', 'url' => 'http://yahoo.com', 'browsers' => 'popular' }
  end

end
