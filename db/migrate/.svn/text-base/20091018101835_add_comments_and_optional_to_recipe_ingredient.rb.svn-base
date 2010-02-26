class AddCommentsAndOptionalToRecipeIngredient < ActiveRecord::Migration
  def self.up
     add_column :recipe_ingredients, :comment, :string
     add_column :recipe_ingredients, :optional, :boolean
  end

  def self.down
     remove_column :recipe_ingredients, :comment
     remove_column :recipe_ingredients, :optional
  end
end
