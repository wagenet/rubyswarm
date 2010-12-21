class ClientRun < ActiveRecord::Base

  RUNNING = 1
  DONE = 2

  belongs_to :client
  belongs_to :run

  scope :running, where(:status => RUNNING)
  scope :done, where(:status => DONE)

  # TODO: Should these be better?
  validates :run_id,    :presence => true
  validates :client_id, :presence => true

  def running?
    status == RUNNING
  end

  def done?
    status == DONE
  end

end
