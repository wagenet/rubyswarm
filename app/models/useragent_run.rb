class UseragentRun < ActiveRecord::Base

  IN_PROGRESS = 1

  belongs_to :run
  belongs_to :useragent

  #TODO: Better association validation
  validates :run_id,       :presence => true
  validates :useragent_id, :presence => true
  validates :max,          :presence => true

  scope :pending, where("runs < max")

  def start_run
    return false if new_record?

    self.runs += 1
    self.status = IN_PROGRESS
    save(false)
  end

end
