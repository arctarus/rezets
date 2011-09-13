class Invitation < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20

  belongs_to :sender,   :foreign_key => "sender_id",    :class_name => "User"
  belongs_to :receiver, :foreign_key => "receiver_id",  :class_name => "User"

  validates_presence_of :email

  before_save :generate_token

  def generate_token
    self.token = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--")
  end

  def expired?
    created_at < 1.week.ago
  end

  def accepted_by(user)
    update_attributes :updated_at => Time.now,
                      :receiver => user
  end
end
