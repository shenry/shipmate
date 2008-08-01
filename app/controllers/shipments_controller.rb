class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :get_wineries, :new_winery, :only => [:edit, :new, :create, :additional]
  before_filter :reject_carrier_access, :only => [:index, :additional, :new, :create, :edit, :update, :delete]

  def index
    #This method is no loger supported.... might as well delete it and see what breaks.
    @shipments = Shipment.find(:all, :conditions => ["ship_date >= ?", STD_CUTOFF_DATE])
  end
  
  def calendar
    start_date = (Time.now.beginning_of_week - 1).to_date # Set start date to Sunday in current week
    end_date = (start_date.next_month.next_week - 2).to_date # Set end date to Saturday in last week to display
    @date_range = (start_date..end_date).to_a
    @shipments = @current_user.accessible_shipments.select do |s|
      s.ship_date >= start_date && s.ship_date <= end_date
    end
    ship_dates = @shipments.collect {|s| s.ship_date}.uniq! # Gets array of ship dates within date range
    @ship_hash = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) } # Initialize default hash to hold values
    ship_dates.each do |date|
      @ship_hash[date] = @shipments.select { |event| event.ship_date == date }
    end
  end
  
  def home
    #This is the default load page upon login. Users see the shipments relevant to them and have the appropriate access levels.
    @item_list = [] # This is a blank array for the purpose of the drop-down box feature that no longer is completely useful.
                    # May be deprecated soon..... 
    case when @current_user.access == 'Global' # Check if current user has global priveliges
      @shipments = Shipment.find(:all, :include => [:to_winery, :from_winery], :order => ["ship_date ASC"], 
        :conditions => ["ship_date > ?", STD_CUTOFF_DATE]) # Creates object containing all viewable shipments
    when @current_user.access == 'Winery' # Checks if current user has winery priveliges
      @shipments = get_winery_accessible_shipments(@current_user, STD_CUTOFF_DATE) # creates object containing shipments
                                                                                   # related to the wineries that this user
                                                                                   # can access.
    when @current_user.access == 'Carrier' # Checks if the current user has carrier priveliges
      @shipments = get_carrier_accessible_shipments(@current_user, STD_CUTOFF_DATE) # creates object containing shiments
                                                                                    # related to the carriers shipping 
                                                                                    # the shipments (uh... sure)
    end
  end
  
  def archive #might be deprecated....
    # This should actually be called 'filter' or something else... my intention was to make an Archive feature but
    # a filter feature seemed more handy. I ended up adding some freeware js code to make the shipment tables sortable.
    # That should make finding the shipments easy enough. And it's all client-side so it's speedy. This feature might
    # be rolled into a bona-fide archive feature if that seems like a worthwhile feature. I've never cared about the
    # shipments I made a month or more ago, so maybe this is trash.
    category = params[:archive][:category] # Get filter category
    item = params[:archive][:item] # Get filter criteria (ie item)
    selected_shipments = Shipment.find(:all, :order => ["ship_date ASC"], :conditions => ["#{category} = ?", item])
      # Filter for all shipments satisfying the above criteria
    @shipments = [] # Create empty array... probably a very bush-league way of doing this
    @current_user.accessible_shipments.each do |shipment| # Loop through the user's accessible shipments
      if selected_shipments.include?(shipment)  # If they intersect the filtered shipments,
        @shipments << shipment  #  add them to the array @shipments that will be passed to the view template.
      end
    end
    respond_to do |format|
      format.html {render :action => 'home'}
      format.js
    end
  end
  
  def test_complete # This checks to see if the user is finished selecting criteria before allowing them to click 'Go'
    if params[:value] == ""
      @value = nil
    else
      @value = 'test'
    end
  end
  
  def item_list
    # This populates the item dropdown based on the first dropdown (criteria)
    @value = params[:value]
    @item_list = []
    case when @value == 'shipper_id'
      @item_list = Shipper.find(:all, :order => ["name ASC"])
    when @value == 'from_winery_id' || @value == 'to_winery_id'
      @item_list = Winery.find(:all, :order => ["name ASC"])
    end
  end
  
  def additional
    # This feature allows users to create a new shipment based on a shipment that is already created.
    if request.get?
      @shipment = Shipment.find(params[:id])
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      @shipment_url = {:controller => 'shipments', :action => 'create'}
      @method = {:method => :post}
      render :action => 'new'
    elsif request.post?
      @shipment = Shipment.new(params[:shipment])
      if @shipment.save
        flash[:notice] = "Additional shipments successfully created."
        redirect_to home_shipments_path(@current_user)
      end
    end
  end

  def new # Pretty standard, in need of some refactoring.
      @shipment = Shipment.new
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      @shipment_url = {:controller => 'shipments', :action => 'create'}
      @method = {:method => :post}
  end
  
  def create # Pretty standard, in need of some refactoring.
    @shipment = Shipment.new(params[:shipment])
    if @shipment.save
      flash[:notice] = "New shipment successfully created."
      redirect_to home_shipments_path(@current_user)
    else
      flash[:notice] = "There was some error with the shipment... check the ship date and try again."
      @method = {:method => :post}
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      @shipment_url = {:controller => 'shipments', :action => 'create'}
      render :action => 'new'
    end
  end
  
  def update
    @shipment = Shipment.find(params[:id])
    respond_to do |format|
      if @shipment.update_attributes(params[:shipment])
        flash[:notice] = "Shipment successfully updated."
        format.html {redirect_to(home_shipments_path(@current_user))}
        format.js
      else
        format.html { render :action => "edit" }
        format.js   { head :unprocessable_entity }
      end
    end
  end

  def edit # Pretty standard, in need of some refactoring.
    @shipment = Shipment.find(params[:id])
    @shipment_url = {:controller => 'shipments', :action => 'update'}
    @shippers = Shipper.find(:all, :order => ["name ASC"])
    @method = {:method => :put}
  end
  
  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    flash[:notice] = "Shipment successfully deleted."
    redirect_to shipments_path
  end
  
  private # ----------------------------------------------------------
  
  def get_wineries # Prepare wineries array for select boxes.
    @from_wineries = Winery.find(:all, :order => ["name ASC"]) # Creates an array of all wineries that everyone has access to  
    if @current_user.access == 'Global' # Checks if the current user has global access
      @to_wineries = @from_wineries # If so, make their ship-to wineries equal to the ship-from (cuz they have global access)
    else
      @to_wineries = @current_user.wineries.sort { |a, b| a.name <=> b.name } # Otherwise, give them access to ship to wineries
                                                                              # that they have access to.
    end
    
  end
  
  def new_winery
    # Creates a new winery in memory in case the user wants to ship to one that doesn't yet exist.
    # It's used in an Ajax action, and clumsily at that.
    @winery = Winery.new
  end
end
