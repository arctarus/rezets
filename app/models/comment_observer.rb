class CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(comment)
    comment.notify_users
  end

end
