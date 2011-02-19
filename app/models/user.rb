class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

  has_many :user_recipes, :dependent => :destroy
  has_many :recipes, :through => :user_recipes
  has_many :comments
  has_many :invitations_sent, :foreign_key => "sender_id", :class_name => "Invitation"
  has_many :invitations_received, :foreign_key => "receiver_id", :class_name => "Invitation"

  has_and_belongs_to_many :followers, 
    :join_table => 'follows', 
    :class_name => 'User',
    :association_foreign_key => 'follower_id',
    :foreign_key => 'following_id'

  has_and_belongs_to_many :followings,
    :join_table => 'follows', 
    :class_name => 'User',
    :association_foreign_key => 'following_id',
    :foreign_key => 'follower_id'

  validates_presence_of :email, :slug, :name
  validates_uniqueness_of :slug

  has_attached_file :avatar, :styles => {
    :thumb  => "20x20#",
    :medium => "30x30#",
    :large  => "80x80#" }

  scope :featured,
    select('users.*, count(user_recipes.id) num_recipes').
    joins(:user_recipes).
    group('users.id').
    limit(8)

  def to_param
    slug
  end

end
