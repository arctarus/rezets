class InsertDefaultCategories < ActiveRecord::Migration
  def self.up
    categories = ["verduras","carne","pescados y mariscos",
      "aves y caza", "legumbres y patatas", "pastas", "arroces",
      "postres", "sopas y caldos", "ensaladas"]
    categories.each {|c_name|
      c = Category.new :name => c_name
      c.save
    }
  end

  def self.down
    Category.all.each {|c| c.destroy}
  end
end
