class ClientRun < ActiveRecord::Base

  belongs_to :client
  belongs_to :run

  RUNNING = 1
  DONE = 2

  scope :running, where(:status => RUNNING)
  scope :done, where(:status => DONE)

  def running?
    status == RUNNING
  end

  def done?
    status == DONE
  end

end
