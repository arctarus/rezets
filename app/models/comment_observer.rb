class CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(comment)
    recipe = comment.recipe
    users = recipe.comments.collect {|c| c.user}.uniq
    users << recipe.author unless users.include? recipe.author
    users.delete(comment.user)
    users.each do |user|
      UserMailer.comment_recipe(comment, user).deliver
    end
  end

end
