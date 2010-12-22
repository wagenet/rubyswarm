require 'spec_helper'

describe User do
  describe "creation" do
    it "should build a valid object" do
      build_user.should be_valid
    end

    it "should ensure authentication token" do
      create_user.authentication_token.should_not be_nil
    end
  end

  it "should check roles" do
    current_user.role?(:admin).should be_false
    admin_user.role?(:admin).should be_true
  end
end
