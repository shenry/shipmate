class ShippersController < ApplicationController
  before_filter :logged_in, :get_user, :allow_only_global_access

  def index
    # Nothing new here
    @shippers = Shipper.find(:all, :order => ["name ASC"])
  end

  def new
    # Nothing new here
    @shipper = Shipper.new
  end
  
  def create
    # Nothing new here
    @shipper = Shipper.new(params[:shipper])
    if @shipper.save
      flash[:notice] = "New carrier '#{@shipper.name}' successfully created."
      redirect_to shippers_path
    else
      render :action => 'new'
    end
  end

  def edit
    # Nothing new here
    @shipper = Shipper.find(params[:id])
  end
  
  def update
    # Nothing new here
    @shipper = Shipper.find(params[:id])
    if @shipper.update_attributes(params[:shipper])
      flash[:notice] = "Carrier '#{@shipper.name}' successfully updated."
      redirect_to shippers_path
    else
      render :action => 'edit'
    end
  end
end
