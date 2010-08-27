class SessionsController < ApplicationController
  layout 'base'

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    @page_title = "entrar en rezets.com"
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = _("welcome!")
      redirect_back_or_default @user_session.user
    else
      render :action => "new"
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = _("see you soon!")
    redirect_back_or_default :controller => "home", :action => "index"
  end

end
