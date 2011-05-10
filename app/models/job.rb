class Job < ActiveRecord::Base

  RUNNING = 1
  DONE = 2

  belongs_to :user
  has_many :runs, :dependent => :destroy
  has_many :useragent_runs, :through => :runs
  has_many :client_runs, :through => :runs

  serialize :suites

  attr_accessible :name, :browsers, :suites, :url, :revision, :test_creation_date


  #TODO: Better association validation
  validates :user_id,  :presence => true
  validates :name,     :presence => true, :uniqueness => { :scope => :revision }
  validates :browsers, :presence => true
  validates :suites,   :presence => true

  scope :running, where(:status => RUNNING)
  scope :done, where(:status => DONE)

  before_create :setup_runs, :set_test_creation_date

  def running?
    status == RUNNING
  end

  def done?
    status == DONE
  end

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

  def run_started
    return false if done? || running?
    update_attribute(:status, RUNNING)
  end

  def run_completed
    return false unless running?
    update_attribute(:status, DONE)
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
