class ShipmentsController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @shipments = Shipment.find(:all)
  end

  def new
    if params[:id]
      @shipment = Shipment.find(params[:id])
      @wineries = Winery.find(:all).collect {|w| [w.name, w.id]}
    else
      @shipment = Shipment.new
      @wineries = Winery.find(:all).collect {|w| [w.name, w.id]}
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

  def edit
  end
end
