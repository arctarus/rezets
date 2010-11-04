class Category < ActiveRecord::Base
  has_many :recipes

  before_save :slugify_name
  before_update :slugify_name

  scope :with_recipes, 
    where('id in (select category_id from recipes group by category_id)')

  def to_param
    slug
  end

  # before_save
  def slugify_name
    self.slug = name.split(//u).reject { |e| e.length > 1 }.join.strip.gsub(/[^a-z0-9]+/i, '-').downcase 
  end

end
