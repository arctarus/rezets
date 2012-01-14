class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # guest user (not logged in)

    guest
    logged if @user.persisted?
    admin  if @user.id == 1
  end

  def guest
    can [:create, :read, :rookies], User
    can [:read, :print, :email, :email_send], Recipe
    can :read, Category
    can :read, Ingredient
  end

  def logged
    can :manage, User, id: @user.id
    can :manage, Recipe, author_id: @user.id
    can [:read, :create], Invitation, sender_id: @user.id
  end

  def admin
    can :manage, Invitation
    can :manage, Ingredient
  end
end
