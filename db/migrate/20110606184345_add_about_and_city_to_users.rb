class AddAboutAndCityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :about, :text
    add_column :users, :city, :string
    add_column :users, :website, :string
    add_column :users, :twitter, :string
  end

  def self.down
    remove_column :users, :city
    remove_column :users, :about
    remove_column :users, :website
    remove_column :users, :twitter
  end
end
