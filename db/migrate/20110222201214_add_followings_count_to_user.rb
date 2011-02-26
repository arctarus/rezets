class AddFollowingsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :followings_count, :integer
    User.all.each do |u|
      User.update_counters(u.id, :followings_count => u.followings.count)
    end
  end

  def self.down
    remove_column :users, :followings_count
  end
end
