require 'fileutils'

class ChangeRecipePhotoNameToRecipeName < ActiveRecord::Migration
  def self.up
    Recipe.all.each do |r|
      ['original', 'large', 'medium', 'thumb'].each do |size|
        old_path = "public/system/photos/#{r.id}/#{size}"
        old_name = "#{old_path}/#{r.photo_file_name}"
        new_path = "public/system/recipes/#{r.id}/photos/#{size}"
        new_name = "#{new_path}/#{r.slug}.#{r.photo_file_name.split('.').last}"
        FileUtils.mkdir_p new_path
        FileUtils.cp old_name, new_name if File.exists? old_name
        puts "#{old_name} -> #{new_name}"
      end
    end
  end

  def self.down
    Recipe.all.each do |r|
      puts r.photo_file_name
    end
  end
end
