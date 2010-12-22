class Run < ActiveRecord::Base

  belongs_to :job
  has_many :useragent_runs, :dependent => :destroy

  #TODO: Better association validation
  validates :job_id,   :presence => true
  validates :name,     :presence => true
  validates :url,      :presence => true
  validates :browsers, :presence => true

  before_create :setup_useragent_runs

  private

    def setup_useragent_runs
      Useragent.with_browser(browsers).each do |ua|
        useragent_runs.build(:useragent_id => ua.id, :max => 1)
      end
    end

end
