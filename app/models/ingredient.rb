class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, :through => :recipe_ingredients

  scope :most_popular, 
    select('count(ingredients.id) count, ingredients.*').
    joins(:recipe_ingredients).
    group('ingredients.id'). 
    order('count desc')

  def to_param
    name
  end

end
