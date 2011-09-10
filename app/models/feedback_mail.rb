class FeedbackMail < MailForm::Base
  attributes :name, :email, :message
  validates_presence_of :name, :email, :message

  def headers
    { :to   => "rezets.com@gmail.com",
      :from => self.email }
  end
end
