class Recipe < ActiveRecord::Base
  require 'watermark'

  has_many :user_recipes
  has_many :users,              :through => :user_recipes
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients,        :through => :recipe_ingredients
  has_many :comments
  belongs_to :category
  belongs_to :author,           :foreign_key => "author_id",      :class_name => "User"

  validates_presence_of :name, :directions, :category, :author, :message => "no puede quedar en blanco"
  validates_presence_of :photo_file_name, :message => "es imprescindible que pongas una bien bonita :D"
# validates_attachment_dimensions :image, :minimum => 300, :maximum => 900
  validates_length_of :name, :minimum => 5

  after_update :save_recipe_ingredients
  before_save :slugify_name
  before_update :slugify_name

  accepts_nested_attributes_for :recipe_ingredients, 
    :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }

  has_attached_file :photo,
    :processors => [:watermark],
    :path       => ":rails_root/public/system/:class/:id/:attachment/:style/:slug.:extension",
    :url        => "/system/:class/:id/:attachment/:style/:slug.:extension",
    :styles     => {
      :large  => {
        :geometry       => "500>x500",
        :watermark_path => "#{RAILS_ROOT}/public/images/watermark.png",
        :position       => "Center",
        :watermark      => "20x100"},
      :medium => "300>x300",
      :thumb  => "150>x150" }

  scope :by_author, lambda {|author_id|
    {:conditions => ["author_id = ?", author_id],
      :limit => 5,
      :order => "created_at desc"}}

  scope :by_category, lambda {|category_id|
    {:conditions => ["category_id = ?", category_id],
    :limit => 5,
    :order => "created_at desc"}}

  scope :not_in, lambda {|recipes_ids|
    {:conditions => ["recipes.id not in (?)",recipes_ids]}}
      
  Paperclip.interpolates :slug do |attachment, style|
    attachment.instance.slug
  end

  def self.random
    ids = Recipe.all.collect {|r| r.id }
    Recipe.find(ids[rand(ids.size)]) unless ids.blank?
  end

  def new_recipe_ingredients_attributes=(ri_attr)
    recipe_ingredients.build(ri_attr)
  end

  def existing_recipe_ingredients_attributes=(ri_attr)
    recipe_ingredients.reject(&:new_record?).each do |ri|
      attributes = ri_attr[ri.id.to_s]
      if attributes
        ri.update_attributes(attributes)
      else
        recipe_ingredients.delete(ri)
      end
    end
  end

  def save_recipe_ingredients
    recipe_ingredients.each do |ri|
      ri.save(false)
    end
  end

  def author?(user)
    return self.author == user
  end

  def to_param
    "#{id}-#{slug}"
  end

  # before_save
  def slugify_name
#   accents = { 
#     ['á','à','â','ä','ã'] => 'a',
#     ['Ã','Ä','Â','À'] => 'A',
#     ['é','è','ê','ë'] => 'e',
#     ['Ë','É','È','Ê'] => 'E',
#     ['í','ì','î','ï'] => 'i',
#     ['Í','Î','Ì','Ï'] => 'I',
#     ['ó','ò','ô','ö','õ'] => 'o',
#     ['Õ','Ö','Ô','Ò','Ó'] => 'O',
#     ['ú','ù','û','ü'] => 'u',
#     ['Ú','Û','Ù','Ü'] => 'U',
#     ['ç'] => 'c', ['Ç'] => 'C',
#     ['ñ'] => 'n', ['Ñ'] => 'N'
#   }
#   str = self.name
#   accents.each do |ac,rep|
#     ac.each do |s|
#       str = str.gsub(s, rep)
#     end
#   end

    self.slug = str.split(//u).reject { |e| e.length > 1 }.join.strip.gsub(/[^a-z0-9]+/i, '-').downcase 
  end

  def title
    _("%{recipe} recipe by %{author}") % {
      :recipe => name.downcase, :author => author.name}
  end
  
end
