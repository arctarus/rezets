class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, :through => :recipe_ingredients

  named_scope :most_popular, :select => "count(ingredients.id) count, ingredients.*",
    :joins => :recipe_ingredients, 
    :group => "id", 
    :order => "count desc"

  def to_param
    self.name
  end

end
