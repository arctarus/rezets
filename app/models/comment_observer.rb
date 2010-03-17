class CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(comment)
    recipe = comment.recipe
    users = recipe.comments.collect {|c| c.user}.uniq
    users << recipe.author unless users.include? recipe.author
#   users.delete(current_user)
    users.each do |user|
      UserMailer.deliver_comment_recipe(comment, user)
    end
  end

end
