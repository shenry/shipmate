# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '307b8a34c931d02b46ef87ce7449305c'
  
  private # -----------------------------------------------------------------
  
  def reject_carrier_access # this is meant to carrier users monkeying with the URL, then kicks them out of the session
    if @current_user.access == 'Carrier'
      flash[:notice] = "You do not have access to this function, you've been logged out."
      session[:user_id] = nil
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
  
  def allow_only_global_access # this is meant to kick out users monkeying with the URL accessing priveliged resources
    if @current_user.access != 'Global'
      flash[:notice] = "You do not have access to this function, you've been logged out."
      session[:user_id] = nil
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
  
  def logged_in
    #Checks to see if there is a :user_id param in the session hash, no value means the user is not logged in.
    if !session[:user_id]
      flash[:notice] = "You are not logged in."
      redirect_to :controller => 'admin', :action => 'index' #fix this once a proper site is made.
      return false
    end
  end
  
  def get_user
    #get the User object of the logged-in user. This is used throughout the application to determine access level
    #to functions and links and the like.
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end
  
end
