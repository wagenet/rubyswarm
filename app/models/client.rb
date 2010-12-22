class Client < ActiveRecord::Base

  TIMEOUT = 5.minutes

  belongs_to :user
  belongs_to :useragent
  has_many :client_runs

  attr_accessible :user_id, :useragent_id, :os, :useragentstr, :ip

  # TODO: Should we have better association validation?
  validates :user_id,      :presence => true
  validates :useragent_id, :presence => true
  validates :os,           :presence => true
  validates :useragentstr, :presence => true
  validates :ip,           :presence => true

  scope :timedout, lambda{ where("updated_at < ? AND active = ?", Time.now - TIMEOUT, true) }

  class << self

    def for_current(user, uastr, ip)
      uadata = Useragent.parse(uastr)
      useragent = Useragent.find_by_useragent(uadata)

      params = { :user_id => user.id, :useragent_id => useragent.id, :os => uadata[:os], :useragentstr => uastr, :ip => ip }

      # Assume expired ones have been wiped
      if existing = where(params).first
        existing.update_attribute(:active, true)
        existing
      else
        client = new(params)
        client.active = true
        client.save
        client
      end
    end

    def expire
      timedout.each(&:timeout)
    end

  end

  def timeout
    update_attribute(:active, false)
    client_runs.running.destroy_all
    # TODO: Decrement UseragentRuns count
  end

  def serializable_hash(*)
    super.except('ip')
  end

  def to_xml(options = {})
    (options[:except] ||= []) << :ip
    super
  end

end
