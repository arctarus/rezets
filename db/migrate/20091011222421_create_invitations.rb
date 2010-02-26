class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.references :sender, :null => false
      t.references :receiver
      t.string :email
      t.string :token, :null => false, :uniq => true

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
