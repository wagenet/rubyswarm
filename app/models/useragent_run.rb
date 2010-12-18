class UseragentRun < ActiveRecord::Base

  belongs_to :run
  belongs_to :useragent

end
