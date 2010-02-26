class UpdateCategories < ActiveRecord::Migration
  def self.up
    update_categories = {
      "legumbres y patatas" => "legumbres",
      "arroces" => "arroz",
      "pastas" => "pasta",
      "verduras" => "verduras y hortalizas" }

    update_categories.each do |k,v|
      c = Category.find_by_name(k)
      c.update_attribute("name",v) unless c.nil?
    end

    categories = ["patatas","huevos y lacteos","soja y derivados",
      "frutas", "embutidos"]
    categories.each do |c_name|
      c = Category.new :name => c_name
      c.save
    end
  end

  def self.down
    update_categories = {
      "legumbres y patatas" => "legumbres",
      "arroces" => "arroz",
      "pastas" => "pasta",
      "verduras" => "verduras y hortalizas" }

    update_categories.each do |k,v|
      c = Category.find_by_name(v)
      c.update_attribute("name",k) unless c.nil?
    end

    categories = ["patatas","huevos y lacteos","soja y derivados",
      "frutas", "embutidos"]
    categories.each do |c_name|
      c = Category.find_by_name c_name
      c.destroy unless c.nil?
    end
  end
end
