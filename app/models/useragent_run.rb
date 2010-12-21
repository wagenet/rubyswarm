class UseragentRun < ActiveRecord::Base

  belongs_to :run
  belongs_to :useragent

  #TODO: Better association validation
  validates :run_id,       :presence => true
  validates :useragent_id, :presence => true
  validates :max,          :presence => true

end
