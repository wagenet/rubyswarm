class ClientRun < ActiveRecord::Base

  RUNNING = 1
  DONE = 2
  FAILED = 3

  TIMEOUT = 5.minutes

  belongs_to :client
  belongs_to :run

  # TODO: Should these be better?
  validates :run_id,    :presence => true
  validates :client_id, :presence => true
  validates :fail,      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_blank => true
  validates :error,     :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_blank => true
  validates :total,     :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_blank => true

  scope :running, where(:status => RUNNING)
  scope :done, where(:status => DONE)
  scope :timedout, lambda{ where("updated_at < ? AND status = ?", Time.now - TIMEOUT, RUNNING) }

  before_destroy :notify_cancelled

  class << self
    def expire
      timedout.each(&:timeout)
    end
  end

  def running?
    status == RUNNING
  end

  def failed?
    status == FAILED
  end

  def done?
    status == DONE
  end

  def timeout
    return false unless running?
    update_attribute(:status, FAILED)
    notify_cancelled(true)
  end

  def save_results(attrs)
    self.fail = attrs[:fail] || 0
    self.error = attrs[:error] || 0
    self.total = attrs[:total] || 0
    self.status = (self.fail + self.error > 0) ? FAILED : DONE
    self.results = attrs[:results]
    save
  end

  private

    def notify_cancelled(force = false)
      if (running? || done?) || force
        uar = UseragentRun.where(:useragent_id => client.useragent_id, :run_id => run_id).first
        uar.run_cancelled if uar
      end
    end

end
