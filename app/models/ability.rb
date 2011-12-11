class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can [:read, :following, :likes], User
    can :manage, User, id: user.id

    can :read, Recipe
    can :manage, Recipe, author_id: user.id
    can :read, Category
    can :read, Ingredient

    can [:read, :create], Invitation, sender_id: user.id

    # logged
    if not user.new_record?
      can [:follow, :unfollow], User
    end

    # admin
    if user.id == 1
      can :manage, Invitation
      can :manage, Ingredient
    end
 end
end
