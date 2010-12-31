require 'spec_helper'

describe "Clients" do
  before(:each) do
    @client = create_client
  end

  describe "signed out" do
    it "should show list of clients" do
      visit(clients_path)
      page.should have_content(@client.useragentstr)
      click_link('Show')
      current_path.should == client_path(@client)
    end

    it "should show client" do
      visit(client_path(@client))
      page.should have_content(@client.useragentstr)
    end
  end
end
