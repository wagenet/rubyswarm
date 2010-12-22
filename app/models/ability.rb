class Ability
  include CanCan::Ability

  def initialize(user = nil)
    can :read, [Client, Useragent]

    if user
      if user.role? :admin
        can :manage, :all
      else
        can :manage, Job, :user_id => user.id

        # TODO: Should we clean this up a bit more?
        can(:manage, Run){|r| r.job.user_id == user.id }

        can :run, UseragentRun
      end
    end
  end
end
