class AddFollowersCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :followers_count, :integer, :default => 0
    User.all.each do |u|
      User.update_counters(u.id, :followers_count => u.followers.count)
    end

  end

  def self.down
    remove_column :users, :followers_count
  end
end
