class AdminController < ApplicationController
  before_filter :logged_in, :except => [:index, :login]
  before_filter :get_user
  
  def index
  end
  
  def menu
  end
  
  def login
    if request.post?
      found_user = User.authenticate(params[:login], params[:password])
      if found_user
        session[:user_id] = found_user.id
        flash[:notice] = "Login successful."
        redirect_to home_user_path(User.find(session[:user_id]))
      else
        flash[:notice] = "Username/password combination incorrect. Please check your caps lock and try again."
        render :action => 'index'
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have logged out."
    redirect_to :action => 'index'
  end
end
