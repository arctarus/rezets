class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, User
    can :manage, User, :id => user.id

    can :read, Recipe
    can :manage, Recipe, :author_id => user.id

    can [:read, :create], Invitation, :sender_id => user.id

    # admin
    if user.id == 1
      can :manage, Invitation
    end
 end
end
