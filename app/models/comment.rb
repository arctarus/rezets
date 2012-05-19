class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe, :touch => true

  validates_presence_of :body, :user, :recipe, :message => _("Can't be blank")

  after_create :notify_recipe_authors_and_commenters

  def self.new_with_recipe(args = {}, recipe)
    new args.merge(:recipe_id => recipe.id)
  end

  def notify_recipe_authors_and_commenters
    users = recipe.author_and_commenters_except(user)

    users.each do |user|
      UserMailer.comment_recipe(self, user).deliver
    end
  end

end
