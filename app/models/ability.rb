class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Client, Useragent]

    if user
      if user.role? :admin
        can :manage, :all
      else
        can :manage, Job, :user_id => user.id
        # TODO: Do we want to lock this down a bit more?
        can(:manage, Run){|r| r.job.user_id == user.id }
      end
    end
  end
end
