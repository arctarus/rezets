class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

  has_many :user_recipes, :dependent => :destroy
  has_many :recipes, :through => :user_recipes
  has_many :comments

  validates_presence_of :email, :slug, :name
  validates_uniqueness_of :slug

  has_attached_file :avatar, :styles => {
    :thumb  => "20>x20",
    :medium => "30>x30",
    :large  => "80>x80" }

  scope :featured,
    select('users.*, count(user_recipes.id) num_recipes').
    joins(:user_recipes).
    group('users.id').
    limit(8)

  def to_param
    slug
  end

end
