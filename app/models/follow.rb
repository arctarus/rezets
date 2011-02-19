class Follow < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', :foreign_key => :following_id
  belongs_to :following, :class_name => 'User', :foreign_key => :follower_id
end
