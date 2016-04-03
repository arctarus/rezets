require 'watermark'

class Recipe < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  has_many :user_recipes
  has_many :users,              :through => :user_recipes
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients,        :through => :recipe_ingredients
  has_many :comments,           :include => :user
  belongs_to :category,         :touch => true

  belongs_to :author, :foreign_key => :author_id,
                      :class_name => "User",
                      :touch => true,
                      :counter_cache => true

  has_many :user_likes, :foreign_key => :recipe_id, 
                        :class_name => 'Like'

  has_many :likes, :through => :user_likes,
                   :source => :user

  validates_presence_of :name, :directions, :category, :author, :message => _("Can't be blank")
  validates_presence_of :photo_file_name, :message => _("It is imperative that you put a really nice one ;)")
  validates_length_of :name, :minimum => 5

  after_update :save_recipe_ingredients
  before_save :slugify_name
  before_update :slugify_name
  after_validation :move_photo_if_name_change

  accepts_nested_attributes_for :recipe_ingredients, 
    :allow_destroy => :true,
    :reject_if => :all_blank

  Paperclip.interpolates :slug do |attachment, style|
    attachment.instance.slug
  end

  has_attached_file :photo,
    :storage => :s3,
    :bucket  => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :processors => [:watermark],
    :path       => Rails.root.join("public/system/:class/:id/:attachment/:style/:slug.:extension").to_s,
    :url        => "/system/:class/:id/:attachment/:style/:slug.:extension",
    :styles     => {
      :large  => {
        :geometry       => "500x375#",
        :watermark_path => Rails.root.join("public/images/watermark.png").to_s,
        :position       => "center",
        :watermark      => "30x100"
      },
      :medium => "310x240#",
      :thumb  => "100x100#" }

  validates_attachment_content_type :photo, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  scope :most_popular,
    includes(:category, :ingredients , :likes, :author).
    order("likes_count desc, updated_at desc")

  scope :freshly_made,
    includes([:category, :author]).order("updated_at desc").limit(8)

  scope :by_author, lambda {|author_id|
    where(author_id: author_id).
    order("created_at desc")}

  scope :by_category, lambda {|category_id|
    includes(:category, :ingredients , :likes, :author).
    where(category_id: category_id).
    order("likes_count desc, updated_at desc")}

  scope :rejecting, lambda {|recipes|
    where("recipes.id not in (?)", Array(recipes).map(&:id))}

  scope :user_page, lambda {|order|
    order = order == "name" ? "name asc" : "updated_at desc"
    order(order).
    includes(:category, :recipe_ingredients => :ingredient)
  }

  def self.find_by_url!(url)
    id = url.split('-', 2).first
    where(id: id).includes(recipe_ingredients: :ingredient).first!
  rescue ActiveRecord::StatementInvalid => exception
    Rollbar.info(exception)
    raise ActiveRecord::RecordNotFound
  end

  def self.cache_key
    "recipes/#{maximum(:updated_at).utc.to_s(:number)}"
  end

  def new_recipe_ingredients_attributes=(ri_attr)
    recipe_ingredients.build(ri_attr)
  end

  def existing_recipe_ingredients_attributes=(ri_attrs)
    recipe_ingredients.reject(&:new_record?).each do |ri|
      if ri_attr = ri_attrs[ri.id.to_s]
        ri.update_attributes(ri_attr)
      else
        recipe_ingredients.delete(ri)
      end
    end
  end

  def save_recipe_ingredients
    recipe_ingredients.each do |ri|
      ri.save(:validate => false)
    end
  end

  def author?(user)
    author == user
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slugify_name
    self.slug = name.parameterize
  end

  def title
    _("%{recipe} recipe by %{author}") % {
      recipe: name.downcase, 
      author: author.name}
  end

  def author_and_commenters_except(user)
    User.where(id: comments.map(&:user_id) + [author_id] - [user.id])
  end

  def has_photo?
    self.photo.url != "/photos/original/missing.png"
  end

  def recipes_same_category(n = 3)
    @recipes_same_category ||= Recipe.
      where(:category_id => self.category_id).
      rejecting([*self.recipes_same_author, self]).
      includes(:author).
      order('created_at desc').
      limit(n)
  end

  def recipes_same_author(n = 3)
    @recipes_same_author ||= self.author.recipes.
      rejecting(self).
      includes(:author, :category).
      order('created_at desc').
      limit(n)
  end
  
  private

  def move_photo_if_name_change
    if name_changed?
      (photo.styles.keys + [:original]).each do |style|
        move_style_photo(style)
      end
    end
  end

  def move_style_photo(style)
    path = File.path photo.path(style)
    extension = File.extname path
    new_name = File.join(File.dirname(path), name.parameterize + extension)
    FileUtils.move path, new_name if File.exist?(path)
  end
end
