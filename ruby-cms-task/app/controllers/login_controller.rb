class LoginController < ApplicationController
  
  layout 'application'

  before_action :confirm_if_logged_in, except: [:login, :validate_login, :logout]

  def login
  end

  def validate_login
  	user_info = login_params
    puts 
  	if user_info[:name].eql?("Darth") && user_info[:password].eql?("Vader")
  		session[:user_login_key] = rand(1000..2000)
      redirect_to(controller: 'products', action: 'index')
  	else
  		flash["error"] = "Oops name/password info entered not valid, please try again!"
  		render('login')
  	end
  end

  def logout
    session[:user_login_key] = nil
    redirect_to(controller: 'cms_task', action: 'index')
  end

  def close_alert
    flash[:error] = nil
    render('login')
  end   
  
  private 
    def login_params
      params.require(:user).permit(:name, :password)
    end

  
 
end
