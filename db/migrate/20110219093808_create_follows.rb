class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows, :id => false do |t|
      t.references :follower
      t.references :following

      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end
