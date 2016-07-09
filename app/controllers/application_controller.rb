class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :logged_in?

  def logged_in?
    !current_user.nil?
  end

  def require_login!
    redirect_to new_session_url if !logged_in?
  end

  def login!(user)
    session[:session_token] = user.session_token
  end

  def logout!
    session[:session_token] = nil
    @current_user = nil
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
end
