class FeedbackController < ApplicationController

  def new
    @feedback_form = FeedbackForm.new
  end

  def create
    @feedback_form = FeedbackForm.new(params[:feedback_form])

    if @feedback_form.deliver
      redirect_to root_url, :notice => _("thanks for your help")
    else
      render :new
    end
  end

end
