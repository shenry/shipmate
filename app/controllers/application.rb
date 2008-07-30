# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '307b8a34c931d02b46ef87ce7449305c'
  
  private # -----------------------------------------------------------------
  
  def reject_carrier_access
    if @current_user.access == 'Carrier'
      flash[:notice] = "You do not have access to this function, you've been logged out."
      session[:user_id] = nil
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
  
  def allow_only_global_access
    if @current_user.access != 'Global'
      flash[:notice] = "You do not have access to this function, you've been logged out."
      session[:user_id] = nil
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
  
  def get_winery_accessible_shipments(current_user, cutoff_date)
    user_wineries = current_user.wineries.collect {|c| c.id}
    @shipments = []
    winery_shipments = Shipment.find(:all, :order => ['ship_Date ASC'], 
                  :conditions => ["ship_date > ?", cutoff_date]).each do |shipment|
      if user_wineries.include?(shipment.to_winery_id) || user_wineries.include?(shipment.from_winery_id)
        @shipments << shipment
      end
    end
    return @shipments
  end
  
  def get_carrier_accessible_shipments(current_user, cutoff_date)
    @shipments = Shipment.find(:all, :order => ['ship_date ASC'], 
                  :conditions => ["ship_date > ? AND shipper_id = ?", cutoff_date, current_user.shipper_id])
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
