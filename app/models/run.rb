class Run < ActiveRecord::Base

  RUNNING = 1
  DONE = 2

  belongs_to :job
  has_many :useragent_runs, :dependent => :destroy
  has_many :client_runs, :dependent => :destroy

  #TODO: Better association validation
  validates :job_id,   :presence => true
  validates :name,     :presence => true
  validates :url,      :presence => true
  validates :browsers, :presence => true

  before_create :setup_useragent_runs

  def running?
    status == RUNNING
  end

  def done?
    status == DONE
  end

  def run_started
    return false if done? || running?
    update_attribute(:status, RUNNING)
    job.run_started
  end

  def run_completed
    return false unless running?
    if useragent_runs.all?(&:done?)
      update_attribute(:status, DONE)
      job.run_completed
    end
  end

  private

    def setup_useragent_runs
      Useragent.with_browser(browsers).each do |ua|
        useragent_runs.build(:useragent_id => ua.id, :max => 1)
      end
    end

end
