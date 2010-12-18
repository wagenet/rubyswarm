class Client < ActiveRecord::Base

  TIMEOUT = 5.minutes

  belongs_to :user
  belongs_to :useragent
  has_many :client_runs

  scope :timedout, lambda{ where("updated_at < ? AND active = 1", Time.now - TIMEOUT) }

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
        create(params.merge(:active => true))
      end
    end

    def expire
      timedout.each(&:timeout)
    end

  end

  def timeout
    update_attributes(:active => false)
    client_runs.running.destroy_all
    # TODO: Decrement UseragentRuns count
  end

end
