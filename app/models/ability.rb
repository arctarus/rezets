class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can [:create, :read, :following, :likes], User
    can [:read, :print, :email, :email_send], Recipe
    can :read, Category
    can :read, Ingredient

    # logged
    if not user.new_record?
      can [:follow, :unfollow], User
      can :manage, User, id: user.id
      can :manage, Recipe, author_id: user.id
      can [:read, :create], Invitation, sender_id: user.id
    end

    # admin
    if user.id == 1
      can :manage, Invitation
      can :manage, Ingredient
    end
 end
end
