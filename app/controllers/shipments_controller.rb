class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :get_wineries, :new_winery, :only => [:edit, :new, :create, :additional]

  def index
    @shipments = Shipment.find(:all, :conditions => ["ship_date >= ?", Time.now.to_date - 2])
  end
  
  def item_list
    case when @current_user.access == 'Global'
      if params[:value] == 'Carrier'
        @item_list = Shipper.find(:all, :order => ["name ASC"])
      end
    end
  end
  
  def additional
    if request.get?
      @shipment = Shipment.find(params[:id])
      render :action => 'new'
    elsif request.post?
      @shipment = Shipment.new(params[:shipment])
      if @shipment.save
        flash[:notice] = "Additional shipments successfully created."
        redirect_to :action => 'index'
      end
    end
  end

  def new
    #if params[:id]
    #  @shipment = Shipment.find(params[:id])
    #else
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      @shipment = Shipment.new
      @shipment_url = {:controller => 'shipments', :action => 'create'}
    #end
  end
  
  def create
    @shipment = Shipment.new(params[:shipment])
    if @shipment.save
      flash[:notice] = "New shipment successfully created."
      redirect_to home_user_path(@current_user)
    else
      render :action => 'new'
    end
  end
  
  def update
    @shipment = Shipment.find(params[:id])
    respond_to do |format|
      if @shipment.update_attributes(params[:shipment])
        flash[:notice] = "Shipment successfully updated."
        format.html {redirect_to(@shipment)}
        format.js
      else
        format.html { render :action => "edit" }
        format.js   { head :unprocessable_entity }
      end
    end
  end

  def edit
    @shipment = Shipment.find(params[:id])
    @shipments_url = {:controller => 'shipments', :action => 'update'}
  end
  
  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    flash[:notice] = "Shipment successfully deleted."
    redirect_to shipments_path
  end
  
  private # ----------------------------------------------------------
  
  def get_wineries
    @wineries = Winery.find(:all, :order => ["name ASC"])
  end
  
  def new_winery
    @winery = Winery.new
  end
end
