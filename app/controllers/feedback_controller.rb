class FeedbackController < ApplicationController

  def new
    @feedback_mail = FeedbackMail.new
  end

  def create
    @feedback_mail = FeedbackMail.new(params[:feedback_mail])

    if @feedback_mail.deliver
      redirect_to root_url, :notice => _("thanks for your help")
    else
      render 'new'
    end
  end

end
