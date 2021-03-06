class Category < ActiveRecord::Base
  has_many :recipes

  before_save :slugify_name
  before_update :slugify_name

  scope :with_recipes, 
    where(id: Recipe.select(:category_id).group(:category_id))

  def to_param
    slug
  end

  private

  def slugify_name
    self.slug = name.parameterize 
  end

end
