class AddLikesCountToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :likes_count, :integer, :default => 0
    Recipe.all.each do |r|
      Recipe.update_counters(r.id, :likes_count => r.likes.count)
    end
  end

  def self.down
    remove_column :recipes, :likes_count
  end
end
