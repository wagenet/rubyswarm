class UseragentRun < ActiveRecord::Base

  RUNNING = 1
  DONE = 2

  belongs_to :run
  belongs_to :useragent

  #TODO: Better association validation
  validates :run_id,       :presence => true
  validates :useragent_id, :presence => true
  validates :max,          :presence => true

  scope :pending, where("runs < max")

  def running?
    status == RUNNING
  end

  def done?
    status == DONE
  end

  def start_run(client)
    return false if new_record? || done?

    self.runs += 1
    if self.status != RUNNING
      self.status = RUNNING
      run.run_started
    end
    save(:validation => false)

    cr = client.client_runs.build(:status => ClientRun::RUNNING)
    cr.run_id = run_id
    cr.client = client
    cr.save(:validation => false)
  end

  def run_cancelled
    return false unless (running? || done?) && runs > 0
    self.runs -= 1
    self.status = RUNNING
    save(:validation => false)
  end

  def run_completed
    return false unless running?
    if runs == max
      run.run_completed
      self.status = DONE
      save(:validation => false)
    end
  end

end
