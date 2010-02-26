class RecipeIngredient < ActiveRecord::Base
  attr_accessor :name

  belongs_to :recipe
  belongs_to :ingredient

  validates_uniqueness_of :ingredient_id, :scope => :recipe_id
  validates_presence_of :name

  after_destroy :destroy_ingredient_if_not_use_it
  
  def name
    ingredient.name unless ingredient.nil?
  end

  def name=(ingredient_name)
    ingredients = Ingredient.find_all_by_name(ingredient_name.downcase)
    if ingredients.blank?
      i = Ingredient.new(:name => ingredient_name.downcase)
      return false unless i.save
    else
      i = ingredients.first
    end
    self.ingredient = i
  end

  def destroy_ingredient_if_not_use_it
    ingredient.destroy if not ingredient.nil? and ingredient.recipes.blank?
  end

end
