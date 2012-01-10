class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe, :touch => true
  belongs_to :ingredient

  validates_uniqueness_of :ingredient_id, :scope => :recipe_id
  validates_presence_of :name

  after_destroy :destroy_ingredient_if_not_use_it

  delegate :name, :to => :ingredient, :allow_nil => true

  def name=(ingredient_name)
    self.ingredient = Ingredient.find_or_create_by_name(ingredient_name.downcase)
  end

  def destroy_ingredient_if_not_use_it
    if ingredient and ingredient.recipe_ingredients.blank?
      ingredient.destroy
    end
  end

end
