class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user
# before_filter :set_gettext_locale
  rescue_from ActiveRecord::RecordNotFound, :with => :page_not_found
  rescue_from CanCan::AccessDenied, :with => :access_denied
  before_filter :ensure_domain

  protected

  def page_not_found
    render  :layout   => false,
            :file     => "public/404.html", 
            :status   => 404
  end

  def access_denied(exception)
    render  :layout   => false,
            :file     => "public/403.html", 
            :status   => 403
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = _("You must be logged in to access this page")
      redirect_to new_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = _("You must be logged out to access this page")
      redirect_to user_path(current_user)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end  

  def ensure_domain
    if request.env['HTTP_HOST'] != APP_CONFIG['app_domain']
      redirect_to "http://#{APP_CONFIG['app_domain']}", :status => 301
    end
  end

end
