class RemoveIngredientReferenceRecipe < ActiveRecord::Migration
  def self.up
    remove_column :ingredients, :recipe_id
  end

  def self.down
    add_column :ingredients, :recipe_id
  end
end
