class WineriesController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @wineries = Winery.find(:all, :order => ["name ASC"])
  end

  def new
    @winery = Winery.new
  end
  
  def create
    @winery = Winery.new(params[:winery])
    if @winery.save
      @wineries = Winery.find(:all, :order => ["name ASC"])
      flash[:notice] = "New winery #{@winery.name} added."
      respond_to do |format|
        format.html {redirect_to wineries_path}
        format.js 
      end
    else
      flash[:notice] = "error"
      render :action => 'new'
    end
  end

  def edit
    @winery = Winery.find(params[:id])
  end
  
  def update
    @winery = Winery.find(params[:id])
    if @winery.update_attributes(params[:winery])
      flash[:notice] = "Winery '#{@winery.name}' successfully updated."
      redirect_to wineries_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @winery = Winery.find(params[:id])
    @winery.destroy
    flash[:notice] = "Winery '#{@winery.name}' permanently destroyed."
    redirect_to wineries_path
  end
end
