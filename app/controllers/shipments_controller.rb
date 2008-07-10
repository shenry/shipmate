class ShipmentsController < ApplicationController

  def index
    @shipments = Shipment.find(:all)
  end

  def new
    @shipment = Shipment.new
    @wineries = Winery.find(:all).collect {|w| [w.name, w.id]}
  end

  def edit
  end
end
