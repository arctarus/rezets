class FeedbackController < ApplicationController

  def new
  end

  def create
    UserMailer.feedback(params[:feedback]).deliver
    flash[:notice] = _("thanks for your help")
    redirect_to root_url
  end

end
