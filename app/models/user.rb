class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

  has_many :user_recipes, :dependent => :destroy
  has_many :recipes, :through => :user_recipes
  has_many :categories, :through => :recipes,
                        :group   => 'categories.id',
                        :order   => 'categories.name'

  has_many :authorings, :foreign_key => 'author_id',
                        :class_name => 'Recipe'
  has_many :comments
  has_many :invitations_sent, :foreign_key => "sender_id", 
                              :class_name => "Invitation"

  has_many :invitations_received, :foreign_key => "receiver_id", 
                                  :class_name => "Invitation"

  has_many :follow_followers, :foreign_key => 'following_id',
                              :class_name => "Follow"

  has_many :followers, :through => :follow_followers, 
                       :source => :following,
                       :class_name => "User"

  has_many :follow_followings, :foreign_key => 'follower_id', 
                              :class_name => 'Follow'

  has_many :followings, :through => :follow_followings,
                        :source => :follower,
                        :class_name => 'User'

  has_many :recipe_likes, :foreign_key => :user_id,
                        :class_name => 'Like'

  has_many :likes, :through => :recipe_likes,
                   :source => :recipe


  attr_accessible :name, :email, :slug, :avatar, :city, :website, :twitter, :about, 
    :password, :password_confirmation

  validates_presence_of :email, :slug, :name
  validates_uniqueness_of :slug

  Paperclip.interpolates :slug do |attachment, style|
    attachment.instance.slug
  end

  has_attached_file :avatar, 
    :storage => :s3,
    :bucket  => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :path => Rails.root.join('public/system/:attachment/:id/:style/:filename').to_s,
    :styles => {
      :thumb  => "20x20#",
      :medium => "50x50#",
      :large  => "80x80#" }

  scope :featured, where("recipes_count > 2").
                   order("recipes_count desc, followers_count desc")
  scope :rookies, where("recipes_count between 1 and 2").
                  order("recipes_count desc, followers_count desc")

  def to_param
    slug
  end

  def authenticate!
    UserSession.create! :email => email, :password => password
  end

  def like(recipe)
    likes << recipe unless likes.include? recipe
  end

  def unlike(recipe)
    rl = recipe_likes.find_by_recipe_id(recipe.id)
    rl.destroy if rl
  end

end
