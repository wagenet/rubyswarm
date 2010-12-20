class Job < ActiveRecord::Base

  belongs_to :user
  has_many :runs

  # Should these be actual variables in the db?
  attr_accessor :browsers
  attr_accessor :suites

  before_create :setup_runs

  private

    def setup_runs
      return unless suites

      for name, url in suites
        runs.build(:name => name, :url => url, :browsers => browsers)
      end
    end

end
