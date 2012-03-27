class Category < ActiveRecord::Base
  has_many :recipes

  before_save :slugify_name
  before_update :slugify_name

  scope :with_recipes, 
    where('id in (select category_id from recipes group by category_id)')

  scope :by_author, lambda {|author|
    joins(:recipes).
    where(:recipes => { :author_id => author.id }).
  }

  scope :grouped, group('categories.id')

  def to_param
    slug
  end

  private

  def slugify_name
    self.slug = name.parameterize 
  end

end
