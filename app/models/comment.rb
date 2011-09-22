class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe

  validates_presence_of :body, :user, :recipe, :message => _("Can't be blank")

  def self.new_with_recipe(args = {}, recipe)
    new args.merge(:recipe_id => recipe.id)
  end
end
