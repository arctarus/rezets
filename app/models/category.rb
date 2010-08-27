class Category < ActiveRecord::Base
  has_many :recipes

  before_save :slugify_name
  before_update :slugify_name

  named_scope :with_recipes, :conditions => [
    "id in (select category_id from recipes group by category_id)"]

  def to_param
    slug
  end

  # before_save
  def slugify_name
    self.slug = self.name.split(//u).reject { |e| e.length > 1 }.join.strip.gsub(/[^a-z0-9]+/i, '-').downcase 
  end

end
