class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe

  validates_presence_of :body, :user, :recipe, :message => _("Can't be blank")

  def self.new_with_recipe(args = {}, recipe)
    new args.merge(:recipe_id => recipe.id)
  end

  # Send an email to all user that write a comment to the recipe and
  # the author, except who write the comment
  def notify_users
    users = self.recipe.comments.map(&:user).uniq

    # add recipe author
    users << self.recipe.author unless users.include? self.recipe.author

    # remove commenter
    users.delete(self.user)

    # send emails
    users.each do |user|
      UserMailer.comment_recipe(self, user).deliver
    end
  end
end
