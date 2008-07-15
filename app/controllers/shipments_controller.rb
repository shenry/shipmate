class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :get_wineries, :only => [:edit, :new, :additional]

  def index
    @shipments = Shipment.find(:all, :conditions => ["ship_date >= ?", Time.now.to_date - 2])
  end
  
  def additional
    @shipment = Shipment.find(params[:id])
    render :action => 'new'
  end

  def new
    if params[:id]
      @shipment = Shipment.find(params[:id])
    else
      @shipment = Shipment.new
    end
  end
  
  def create
    @shipment = Shipment.new(params[:shipment])
    if @shipment.save
      flash[:notice] = "New shipment successfully created."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def update
  end

  def edit
    @shipment = Shipment.find(params[:id])
  end
  
  private # ----------------------------------------------------------
  
  def get_wineries
    @wineries = Winery.find(:all).collect {|w| [w.name, w.id]}
  end
end
