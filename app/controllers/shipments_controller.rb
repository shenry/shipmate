class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :get_wineries, :new_winery, :only => [:edit, :new, :create, :additional]
  before_filter :reject_carrier_access, :only => [:index, :additional, :new, :create, :edit, :update, :delete]
  
  def calendar # Bulids the sexy calendar view
    start_date = (Time.now.beginning_of_week - 1).to_date # Set start date to Sunday in current week
    end_date = (start_date.next_month.next_week - 2).to_date # Set end date to Saturday in last week to display
    @date_range = (start_date..end_date).to_a
    # Now collect shipments that a user can view within the calendar date range...
    @shipments = @current_user.accessible_shipments(STD_CUTOFF_DATE).select do |s|
      s.ship_date >= start_date && s.ship_date <= end_date
    end
    ship_dates = @shipments.collect {|s| s.ship_date}.uniq # Gets array of ship dates within date range
    @ship_hash = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) } # Initialize default hash to hold values
    ship_dates.each do |date|
      @ship_hash[date] = @shipments.select { |event| event.ship_date == date }
    end
  end
  
  def home
    #This is the default load page upon login. Users see the shipments relevant to them and have the appropriate access levels.
    if @current_user.access == 'Global' # Check if current user has global priveliges
      # Creates object containing all viewable shipments
      @shipments = Shipment.find(:all, :include => [:to_winery, :from_winery], :order => ["ship_date ASC"], 
        :conditions => ["ship_date > ?", STD_CUTOFF_DATE])
    else
      # creates object containing shipments that this user can access.
      @shipments = @current_user.accessible_shipments(STD_CUTOFF_DATE)
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
        redirect_to calendar_shipments_path(@current_user)
      end
    end
  end
  
  def show
    @shipment = Shipment.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def daily_group
    @shipments = Shipment.find_all_by_ship_date(params[:date])
    respond_to do |format|
      format.js
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
      redirect_to calendar_shipments_path(@current_user)
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
        format.html {redirect_to(calendar_shipments_path(@current_user))}
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
