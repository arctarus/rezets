class AddRecipesCounterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :recipes_count, :integer, :default => 0
    User.all.each do |u|
      User.update_counters(u.id, :recipes_count => u.recipes.count)
    end
  end

  def self.down
    remove_column :users, :recipes_count
  end
end
