class ShippersController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @shippers = Shipper.find(:all, :order => ["name ASC"])
  end

  def new
    @shipper = Shipper.new
  end
  
  def create
    @shipper = Shipper.new(params[:shipper])
    if @shipper.save
      flash[:notice] = "New carrier '#{@shipper.name}' successfully created."
      redirect_to shippers_path
    else
      render :action => 'new'
    end
  end

  def edit
    @shipper = Shipper.find(params[:id])
  end
  
  def update
    @shipper = Shipper.find(params[:id])
    if @shipper.update_attributes(params[:shipper])
      flash[:notice] = "Carrier '#{@shipper.name}' successfully updated."
      redirect_to shippers_path
    else
      render :action => 'edit'
    end
  end
end
