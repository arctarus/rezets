class AddLikesCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :likes_count, :integer, :default => 0
    User.all.each do |u|
      User.update_counters(u.id, :likes_count => u.likes.count)
    end
  end

  def self.down
    remove_column :users, :likes_count
  end
end
