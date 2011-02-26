class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes, :id => false do |t|
      t.references :user
      t.references :recipe
    end
  end

  def self.down
    drop_table :likes
  end
end
