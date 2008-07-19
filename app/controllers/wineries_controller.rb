class WineriesController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @wineries = Winery.find(:all, :order => ["city ASC, name ASC"])
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
  end
end
