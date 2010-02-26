class AlterRecipeIngredientValueAndType < ActiveRecord::Migration
  def self.up
    change_table :recipe_ingredients do |t| 
      t.remove :quantity, :unit
      t.float :value
      t.string :value_type
    end
  end

  def self.down
    change_table :recipe_ingredients do |t|
      t.remove :value, :value_type
      t.integer :quantity
      t.string :unit
    end
  end
end
