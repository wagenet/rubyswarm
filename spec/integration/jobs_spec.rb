require 'spec_helper'

describe "Jobs" do
  before(:each) do
    @job = create_job(:user => current_user)
  end

  describe "normal user" do
    before(:each) do
      sign_in current_user
    end

    it "should show new form" do
      visit(new_job_path)
      current_path.should == new_job_path
      page.should have_content('New job')
    end

    it "should create new job" do
      visit(new_job_path)
      fill_in 'Name', :with => 'Test Job'
      check 'popular'
      fill_in 'Suites', :with => 'Google: http://google.com'
      click_button 'Create Job'

      job = Job.last

      current_path.should == job_path(job)
      page.should have_content("Job was successfully created.")
      job.name.should == 'Test Job'
    end

    it "should handle invalid creation" do
      count = Job.count
      visit(new_job_path)
      click_button 'Create Job'

      Job.count.should == count

      page.body.should =~ /errors? prohibited this job from being saved:/
    end

    it "should destroy job" do
      count = Job.count
      visit jobs_path
      click_link 'Destroy'
      Job.count.should == count - 1
    end

    it "should run jobs" do
      add_headers "HTTP_USER_AGENT" => USERAGENTS[:chrome][:str]
      visit run_jobs_path
      reset_headers
      current_path.should == run_jobs_path
    end

    describe "get run" do
      before(:each) do
        @uadata = USERAGENTS[:chrome]
        add_headers 'HTTP_USER_AGENT' => @uadata[:str],
                    'HTTP_ACCEPT' => 'application/json, text/javascript, */*',
                    'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
      end

      after(:each) do
        reset_headers
      end

      it "should require XHR" do
        remove_header 'HTTP_X_REQUESTED_WITH'
        visit get_run_jobs_path

        page.should have_content("Not allowed")
      end

      it "should find pending run" do
        useragent = create_useragent(:engine => @uadata[:engine], :version => @uadata[:version])
        useragent_run = create_useragent_run(:useragent => useragent)
        visit get_run_jobs_path
        page.body.should == useragent_run.run.to_json
      end

      it "should notify when no runs" do
        visit get_run_jobs_path
        page.body.should == { :message => "Nothing to Run" }.to_json
      end
    end
  end
end
