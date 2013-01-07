class CreateComment

  attr_reader :commenter, :recipe, :comment

  def initialize(user, recipe, comment_attrs)
    @commenter = user
    @recipe = recipe
    @comment_attrs = comment_attrs
  end

  def call
    @comment = @commenter.comments.new(@comment_attrs.merge(:recipe => @recipe))
    if @comment.save
      notify_recipe_authors_and_commenters
    end
    @comment
  end

  private

  def notify_recipe_authors_and_commenters
    users = @recipe.author_and_commenters_except(@commenter)

    users.each do |user|
      UserMailer.comment_recipe(@comment, user).deliver
    end
  end

end
