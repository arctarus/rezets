class Like < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :recipe
end
