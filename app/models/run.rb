class Run < ActiveRecord::Base

  belongs_to :job
  has_many :useragent_runs

  # Should this be an actual variable in the db?
  attr_accessor :browsers

  before_create :setup_useragentruns

  private

    def setup_useragentruns
      return unless browsers

      useragents = %w(popular gbs beta mobile).inject(Useragent.active) do |list, type|
        browsers.include?(type) ? list.send(type) : list
      end

      for ua in useragents
        #TODO: Set the max here
        useragent_runs.build(:useragent_id => ua.id)
      end
    end

end
