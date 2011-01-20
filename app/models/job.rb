class Job < ActiveRecord::Base

  belongs_to :user
  has_many :runs, :dependent => :destroy
  has_many :useragent_runs, :through => :runs

  serialize :suites

  attr_accessible :name, :browsers, :suites, :url, :revision, :test_creation_date


  #TODO: Better association validation
  validates :user_id,  :presence => true
  validates :name,     :presence => true, :uniqueness => { :scope => :revision }
  validates :browsers, :presence => true
  validates :suites,   :presence => true

  before_create :setup_runs, :set_test_creation_date

  def browsers=(val)
    self[:browsers] = case val
      when Array, String
        # This helps keep the order
        Useragent::BROWSER_TYPES.select{|b| val.include?(b) }.join
      else
        nil
    end
  end

  def suites=(val)
    self[:suites] = case val
      when String
        Hash[*val.scan(/^(\w+):\s+(\S+)\s*$/).flatten]
      when Hash
        val
      else
        nil
    end
  end

  private

    def setup_runs
      return unless suites

      for name, url in suites
        runs.build(:name => name, :url => url, :browsers => browsers)
      end
    end

    def set_test_creation_date
      self.test_creation_date ||= Time.now
    end

end
