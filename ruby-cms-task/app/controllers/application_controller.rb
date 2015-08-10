class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private 
  def confirm_if_logged_in
    authenticate
    unless session[:user_login_key]
      redirect_to(controller: 'login', action: 'login') 
      return false
    else
      return true 
    end
  end  

  def authenticate
    if session[:user_login_key]
      reset_session if session[:last_seen] < 10.minutes.ago
      session[:last_seen] = Time.now
    end
  end

end
