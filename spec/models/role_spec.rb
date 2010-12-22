require 'spec_helper'

describe Role do
  describe "creation" do
    it "should be valid" do
      Role.new(:name => 'Role').should be_valid
    end

    it "should require name" do
      Role.new.should_not be_valid
    end

    it "should require unique name" do
      Role.create(:name => 'Role')
      Role.new(:name => 'Role').should_not be_valid
    end
  end
end
