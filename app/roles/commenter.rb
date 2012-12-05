class Commenter
  extend Forwardable

  def_delegator :@user, :id, :id

  def initialize(user)
    @user = user
  end

  def comment_a_recipe(recipe, attrs)
    @user.comments.new(attrs.merge(:recipe => recipe))
  end

end
