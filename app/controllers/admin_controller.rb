class AdminController < ApplicationController
  before_filter :logged_in, :except => [:index, :login]
  before_filter :get_user
  
  def login
    #Accepts login and password from user, proceeds only if post request
    if request.post?
      found_user = User.authenticate(params[:login], params[:password])
      if found_user
        #a match! proceed
        session[:user_id] = found_user.id
        flash[:notice] = "Login successful."
        redirect_to calendar_shipments_path(User.find(session[:user_id]))
      else
        #oops they made some mistake.
        flash[:notice] = "Username/password combination incorrect. Please check your caps lock and try again."
        render :action => 'index'
      end
    end
  end
  
  def logout
    #blank the session data
    session[:user_id] = nil
    flash[:notice] = "You have logged out."
    redirect_to :action => 'index' # will need to change this redirect once I make a proper site
  end
end
