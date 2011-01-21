require 'spec_helper'

describe ClientRunsController do
  describe "admin user" do
    before(:each) do
      sign_in admin_user
    end

    describe "show" do
      it "should find client run" do
        cr = create_client_run

        get 'show', :id => cr.id

        response.should be_success
        response.body.should == cr.results
      end

      it "should notify when no results" do
        cr = create_client_run(:results => nil)

        get 'show', :id => cr.id

        response.should be_success
        response.body.should == 'No Saved Results'
      end
    end
  end

  it "should allow owner to view"
  it "should not allow logged out users to view"

end

