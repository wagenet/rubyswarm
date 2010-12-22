require 'spec_helper'

describe Useragent do
  describe "creation" do
    it "should build a valid record" do
      build_useragent.should be_valid
    end

    it "should require a name" do
      build_useragent(:name => nil).should_not be_valid
    end

    it "should require a unique name" do
      create_useragent(:name => "UA")
      build_useragent(:name => "UA").should_not be_valid
    end

    it "should require an engine" do
      build_useragent(:engine => nil).should_not be_valid
    end

    it "should require a version" do
      build_useragent(:version => nil).should_not be_valid
    end

    it "should require a unique version within engine" do
      create_useragent(:engine => "chrome", :version => "123")
      build_useragent(:engine => "chrome", :version => "123").should_not be_valid
    end
  end

  describe "scopes" do
    it "should return active" do
      create_useragent(:active => true)
      create_useragent(:active => false)
      Useragent.active.count.should == 1
    end

    it "should return popular" do
      create_useragent(:popular => true)
      create_useragent(:popular => false)
      Useragent.popular.count.should == 1
    end

    it "should return gbs" do
      create_useragent(:gbs => true)
      create_useragent(:gbs => false)
      Useragent.gbs.count.should == 1
    end

    it "should return beta" do
      create_useragent(:beta => true)
      create_useragent(:beta => false)
      Useragent.beta.count.should == 1
    end

    it "should return mobile" do
      create_useragent(:mobile => true)
      create_useragent(:mobile => false)
      Useragent.mobile.count.should == 1
    end

    it "should return with browser" do
      create_useragent(:popular => true)
      create_useragent(:gbs => true)
      create_useragent(:beta => true)
      create_useragent(:mobile => true)
      Useragent.with_browser("popular").count.should == 1
      Useragent.with_browser("populargbs").count.should == 2
      Useragent.with_browser("populargbsbeta").count.should == 3
      Useragent.with_browser("populargbsbetamobile").count.should == 4
    end
  end

  describe "class methods" do
    describe "parse" do
      USERAGENTS.each do |name, data|
        it "should parse #{name}" do
          Useragent.parse(data[:str]).should == { :browser => data[:engine], :version => data[:version], :os => data[:os] }
        end
      end
    end

    describe "find_by_useragent" do
      it "should work normally" do
        uadata = USERAGENTS[:chrome]
        ua = create_useragent(:engine => uadata[:engine], :version => '.*')
        Useragent.find_by_useragent(uadata[:str]).should == ua
      end

      it "should work with hash" do
        uadata = USERAGENTS[:chrome]
        ua = create_useragent(:engine => uadata[:engine], :version => '.*')
        hash = Useragent.parse(uadata[:str])
        Useragent.find_by_useragent(hash).should == ua
      end

      it "should run regexp"

      it "should use mysql REGEXP if possible"
    end
  end
end
