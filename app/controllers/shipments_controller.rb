class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :get_wineries, :new_winery, :only => [:edit, :new, :create, :additional]
  before_filter :reject_carrier_access, :only => [:index, :additional, :new, :create, :edit, :update, :delete]

  def index
    @shipments = Shipment.find(:all, :conditions => ["ship_date >= ?", STD_CUTOFF_DATE])
  end
  
  def home
    @item_list = []
    case when @current_user.access == 'Global'
      @shipments = Shipment.find(:all, :include => [:to_winery, :from_winery], :order => ["ship_date ASC"], :conditions => ["ship_date > ?", STD_CUTOFF_DATE])
    when @current_user.access == 'Winery'
      @shipments = get_winery_accessible_shipments(@current_user, STD_CUTOFF_DATE)
    when @current_user.access == 'Carrier'
      @shipments = get_carrier_accessible_shipments(@current_user, STD_CUTOFF_DATE)
    end
  end
  
  def archive
    category = params[:archive][:category]
    item = params[:archive][:item]
    selected_shipments = Shipment.find(:all, :order => ["ship_date ASC"], :conditions => ["#{category} = ?", item])
    @shipments = []
    @current_user.accessible_shipments.each do |shipment|
      if selected_shipments.include?(shipment)
        @shipments << shipment
      end
    end
    respond_to do |format|
      format.html {render :action => 'home'}
      format.js
    end
  end
  
  def test_complete
    if params[:value] == ""
      @value = nil
    else
      @value = 'test'
    end
  end
  
  def item_list
    @value = params[:value]
    @item_list = []
    case when @value == 'shipper_id'
      @item_list = Shipper.find(:all, :order => ["name ASC"])
    when @value == 'from_winery_id' || @value == 'to_winery_id'
      @item_list = Winery.find(:all, :order => ["name ASC"])
    end
  end
  
  def additional
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

  def new
      @shipment = Shipment.new
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      @shipment_url = {:controller => 'shipments', :action => 'create'}
      @method = {:method => :post}
  end
  
  def create
    @shipment = Shipment.new(params[:shipment])
    if @shipment.save
      flash[:notice] = "New shipment successfully created."
      redirect_to home_shipments_path(@current_user)
    else
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

  def edit
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
  
  def get_wineries
    @from_wineries = Winery.find(:all, :order => ["name ASC"])
    if @current_user.access == 'Global'
      @to_wineries = @from_wineries
    else
      @to_wineries = @current_user.wineries.sort { |a, b| a.name <=> b.name }
    end
    
  end
  
  def new_winery
    @winery = Winery.new
  end
end
