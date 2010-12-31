require 'spec_helper'

describe "Useragents" do
  before(:each) do
    @useragent = create_useragent
  end

  describe "signed out" do
    it "should show list of useragents" do
      visit(useragents_path)
      current_path.should == useragents_path
      page.should have_content(@useragent.name)
      click_link('Show')
      current_path.should == useragent_path(@useragent)
    end

    it "should show useragent" do
      path = useragent_path(@useragent)
      visit(path)
      current_path.should == path
      page.should have_content(@useragent.name)
    end

    it "should block new" do
      path = new_useragent_path
      visit(path)
      current_path.should_not == path
    end

    it "should block edit" do
      path = edit_useragent_path(@useragent)
      visit(path)
      current_path.should_not == path
    end
  end

  describe "signed in" do
    before(:each) do
      sign_in admin_user
    end

    it "should show new form" do
      visit(new_useragent_path)
      current_path.should == new_useragent_path
      page.should have_content('New useragent')
    end

    it "should show edit form" do
      path = edit_useragent_path(@useragent)
      visit(path)
      current_path.should == path
      page.should have_content('Editing useragent')
    end

    it "should create new useragent" do
      visit(new_useragent_path)
      fill_in 'Name', :with => 'Test Agent'
      fill_in 'Engine', :with => 'testengine'
      fill_in 'Version', :with => '.*'
      check 'Active'
      check 'Current'
      check 'Popular'
      click_button 'Create Useragent'

      useragent = Useragent.last
      useragent.name.should == 'Test Agent'
      useragent.engine.should == 'testengine'
      useragent.version.should == '.*'
      useragent.should be_active
      useragent.should be_current
      useragent.should be_popular

      current_path.should == useragent_path(useragent)
      page.should have_content("Useragent was successfully created.")
    end

    it "should handle invalid creation" do
      count = Useragent.count
      visit(new_useragent_path)
      click_button 'Create Useragent'

      Useragent.count.should == count

      page.body.should =~ /errors? prohibited this useragent from being saved:/
    end

    it "should update useragent" do
      visit(edit_useragent_path(@useragent))
      fill_in 'Name', :with => 'Updated Name'
      click_button 'Update Useragent'

      @useragent.reload
      @useragent.name.should == 'Updated Name'

      current_path.should == useragent_path(@useragent)
      page.should have_content("Useragent was successfully updated.")
    end

    it "should handle invalid update" do
      visit(edit_useragent_path(@useragent))
      fill_in 'Name', :with => ''
      click_button 'Update Useragent'

      @useragent.reload
      @useragent.name.should_not == ''

      page.body.should =~ /errors? prohibited this useragent from being saved:/
    end

    it "should destroy useragent" do
      count = Useragent.count
      visit useragents_path
      click_link 'Destroy'
      Useragent.count.should == count - 1
    end
  end
end

