# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '307b8a34c931d02b46ef87ce7449305c'
  
  private # -----------------------------------------------------------------
  
  def logged_in
    if !session[:user_id]
      flash[:notice] = "You are not logged in."
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
  
  def get_user
    if session[:user_id]
      @current_user = User.find_by_id(session[:user_id])
    end
  end
  
end
