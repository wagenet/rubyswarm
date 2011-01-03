require 'spec_helper'

describe Ability do
  describe "everyone" do
    before(:each){ @ability = Ability.new }

    it "should allow read Client" do
      @ability.should be_able_to(:read, Client)
    end

    it "should allow read Useragent" do
      @ability.should be_able_to(:read, Useragent)
    end
  end

  describe "non-users" do
    before(:each){ @ability = Ability.new }

    describe "read-only" do
      [Client, Useragent].each do |klass|
        it "should not allow non-read actions for #{klass.name}" do
          [:create, :update, :destroy].each{|action| @ability.should_not be_able_to(action, klass) }
        end
      end
    end

    describe "blocked" do
      [Job, Run, UseragentRun, ClientRun].each do |klass|
        it "should block #{klass.name}" do
          [:read, :create, :update, :destroy].each{|action| @ability.should_not be_able_to(action, klass) }
        end
      end
    end
  end

  describe "normal users" do
    before(:each){ @ability = Ability.new(current_user) }

    describe "blocked" do
      [UseragentRun, ClientRun].each do |klass|
        it "should block #{klass.name}" do
          [:read, :create, :update, :destroy].each{|action| @ability.should_not be_able_to(action, klass) }
        end
      end
    end

    describe "Job" do
      it "should allow manage on own" do
        job = build_job(:user => current_user)
        @ability.should be_able_to(:manage, job)
      end

      it "should block others" do
        job = build_job(:user => other_user)
        [:read, :create, :update, :destroy].each{|action| @ability.should_not be_able_to(action, job) }
      end
    end

    describe "Run" do
      it "should allow manage on own" do
        run = build_run(:job => build_job(:user => current_user))
        @ability.should be_able_to(:manage, run)
      end

      it "should block others" do
        run = build_run(:job => build_job(:user => other_user))
        [:read, :create, :update, :destroy].each{|action| @ability.should_not be_able_to(action, run) }
      end
    end

    it "should allow run for UseragentRun" do
      @ability.should be_able_to(:run, UseragentRun)
    end
  end

  describe "admin" do
    before(:each){ @ability = Ability.new(admin_user) }

    [Client, Useragent, Job, Run, UseragentRun, ClientRun].each do |klass|
      it "should allow manage #{klass.name}" do
        [:read, :create, :update, :destroy].each{|action| @ability.should be_able_to(action, klass) }
      end
    end

    it "should not block others' Jobs" do
      job = build_job(:user => other_user)
      [:read, :create, :update, :destroy].each{|action| @ability.should be_able_to(action, job) }
    end

    it "should not block others' Runs" do
      run = build_run(:job => build_job(:user => other_user))
      [:read, :create, :update, :destroy].each{|action| @ability.should be_able_to(action, run) }
    end

  end
end
