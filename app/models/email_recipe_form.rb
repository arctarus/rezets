class EmailRecipeForm < MailForm::Base
  attributes :recipe, :user, :name, :recipients, :message
  validates_presence_of :name, :recipients

  def headers
    { :to   => "rezets.com@gmail.com",
      :from => self.email }
  end

  def mail
    UserMailer.recipe(self)
  end

  def recipients=(_recipients)
    @recipients = _recipients.split(';').map(&:strip)
  end

  def name
    if @name.present?
      @name
    elsif @user
      @user.name
    end
  end

end
