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
    :thumb => "20x20#",
    :medium => "30x30#",
    :large => "48x48#" }

  def to_param
    slug
  end

end
