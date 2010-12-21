class Job < ActiveRecord::Base

  belongs_to :user
  has_many :runs

  serialize :suites

  attr_accessible :user_id, :name, :browsers, :suites


  #TODO: Better association validation
  validates :user_id,  :presence => true
  validates :name,     :presence => true
  validates :url,      :presence => true
  validates :browsers, :presence => true
  validates :suites,   :presence => true


  before_create :setup_runs

  private

    def setup_runs
      return unless suites

      for name, url in suites
        runs.build(:name => name, :url => url, :browsers => browsers)
      end
    end

end
