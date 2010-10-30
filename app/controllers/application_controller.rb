class ApplicationController < ActionController::Base
  protect_from_forgery
  include FastGettext::Translation

  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  before_filter :set_locale

  def set_locale
    FastGettext.available_locales = ['es', 'en']
    FastGettext.text_domain = 'rezets'
    session[:locale] = I18n.locale = FastGettext.set_locale(params[:locale] || session[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'] || 'en')
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


end
