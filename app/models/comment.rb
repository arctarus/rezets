class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe, :touch => true

  validates_presence_of :body, :user, :recipe, :message => _("Can't be blank")

end
