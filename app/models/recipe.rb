require 'watermark'

class Recipe < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  has_many :user_recipes
  has_many :users,              :through => :user_recipes
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients,        :through => :recipe_ingredients
  has_many :comments
  belongs_to :category

  belongs_to :author, :foreign_key => "author_id",
                      :class_name => "User",
                      :counter_cache => true

  has_many :user_likes, :foreign_key => :recipe_id, 
                        :class_name => 'Like'

  has_many :likes, :through => :user_likes,
                   :source => :user

  validates_presence_of :name, :directions, :category, :author, :message => _("can't be blank")
  validates_presence_of :photo_file_name, :message => _("it is imperative that you put a really nice one ;)")
# validates_attachment_dimensions :image, :minimum => 300, :maximum => 900
  validates_length_of :name, :minimum => 5

  after_update :save_recipe_ingredients
  before_save :slugify_name
  before_update :slugify_name
  after_validation :move_photo_if_name_change

  accepts_nested_attributes_for :recipe_ingredients, 
    :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }

  Paperclip.interpolates :slug do |attachment, style|
    attachment.instance.slug
  end

  has_attached_file :photo,
    :processors => [:watermark],
    :path       => "#{Rails.root.to_s}/public/system/:class/:id/:attachment/:style/:slug.:extension",
    :url        => "/system/:class/:id/:attachment/:style/:slug.:extension",
    :styles     => {
      :large  => {
        :geometry       => "500x375#",
        :watermark_path => "#{Rails.root.to_s}/public/images/watermark.png",
        :position       => "center",
        :watermark      => "30x100"},
      :medium => "310x240#",
      :thumb  => "100x100#" }
    
  scope :by_author, lambda {|author_id|
    where("author_id = ?", author_id).
    order("created_at desc")}

  scope :by_category, lambda {|category_id|
    where("category_id = ?", category_id).
    order("created_at desc")}

  scope :not_in, lambda {|recipes_ids|
    where("recipes.id not in (?)",recipes_ids)}
 

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
      :recipe => name.downcase, :author => author.name}
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
