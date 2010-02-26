class CreateUserRecipes < ActiveRecord::Migration
  def self.up
    create_table :user_recipes do |t|
      t.references :user
      t.references :recipe

      t.timestamps
    end
  end

  def self.down
    drop_table :user_recipes
  end
end
