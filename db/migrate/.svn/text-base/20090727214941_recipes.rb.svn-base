class Recipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :photo_file_name, :string
    add_column :recipes, :photo_content_type, :string
    add_column :recipes, :photo_file_size, :integer
    add_column :recipes, :category_id, :integer, :null => false
    add_column :recipes, :num_persons, :integer
    add_column :recipes, :author_id, :integer, :null => false
  end

  def self.down
    remove_column :recipes, :photo_file_name, :string
    remove_column :recipes, :photo_content_type, :string
    remove_column :recipes, :photo_file_size, :integer
    remove_column :recipes, :category_id, :integer
    remove_column :recipes, :num_persons, :integer
    remove_column :recipes, :author_id, :integer
  end
end
