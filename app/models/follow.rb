class Follow < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', 
                        :foreign_key => :following_id, 
                        :counter_cache => :followers_count

  belongs_to :following, :class_name => 'User', 
                         :foreign_key => :follower_id, 
                         :counter_cache => :followings_count

end
