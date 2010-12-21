class Job < ActiveRecord::Base

  BROWSERS = %w(popular gbs beta mobile).freeze

  belongs_to :user
  has_many :runs

  serialize :suites

  attr_accessible :user_id, :name, :browsers, :suites


  #TODO: Better association validation
  validates :user_id,  :presence => true
  validates :name,     :presence => true
  validates :browsers, :presence => true
  validates :suites,   :presence => true

  before_create :setup_runs

  def browsers=(val)
    self[:browsers] = case val
      when Array
        # This helps keep the order
        BROWSERS.select{|b| val.include?(b) }
      when String
        val
      else
        nil
    end
  end

  def suites=(val)
    self[:suites] = case val
      when String
        returning({}){|ret| val.scan(/^(\w+):\s+(\S+)\s*$/){|name,url| ret[name] = url } }
      when Hash
        val
      else
        nil
    end
  end

  private

    def setup_runs
      return unless suites

      for name, url in suites
        runs.build(:name => name, :url => url, :browsers => browsers)
      end
    end

end
