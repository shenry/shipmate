class UsersController < ApplicationController
  before_filter :logged_in, :get_user
  before_filter :reject_unauthorized_users, :except => [:home, :show]

  def index
    @users = User.find(:all)
  end
  
  def home
    case when @current_user.access == 'Global'
      @shipments = Shipment.find(:all, :order => ['ship_date ASC'], :conditions => ["ship_date > ?", Time.now.to_date - 2])
    when @current_user.access == 'Carrier'
      @shipments = Shipment.find(:all, :order => ['ship_date ASC'], 
                    :conditions => ["ship_date > ? AND shipper_id = ?", Time.now.to_date - 2, @current_user.shipper_id])
    when @current_user.access == 'Winery'
      user_wineries = @current_user.wineries.collect {|c| c.id}
      @shipments = []
      winery_shipments = Shipment.find(:all, :order => ['ship_Date ASC'], 
                    :conditions => ["ship_date > ?", Time.now.to_date - 2]).each do |shipment|
        if user_wineries.include?(shipment.to_winery_id) || user_wineries.include?(shipment.from_winery_id)
          @shipments << shipment
        end
      end
    else
      flash[:notice] = "Not a recognized user access type."
      session[:user_id] = nil
      redirect_to root_path
    end
  end
  
  def show
    @user = User.find(session[:user_id])
  end
  
  def find_access
    #if params[:value] == 'Carrier'
    #  @value = 'Carrier'
    #  @shippers = Shipper.find(:all, :order => ["name ASC"])
    #  respond_to do |format|
    #    format.js
    #  end
    #elsif params[:value] == 'Winery'
    #  @value = 'Winery'
    #  @user_wineries = User.find(session[:user_id]).wineries.collect {|w| w.id}
    #  @wineries = Winery.find(:all, :order => ["name ASC"]).collect {|w| [w.name, w.id]}
    #  respond_to do |format|
    #    format.js
    #  end
    #else
    #  @value = 'nil'
    #end
    if params[:value] == 'Carrier'
      @value = 'Carrier'
    elsif params[:value] == 'Winery'
      @value = 'Winery'
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @user = User.new
    @shippers = Shipper.find(:all, :order => ["name ASC"])
    @wineries = Winery.find(:all, :order => ["name ASC"]).collect {|w| [w.name, w.id]}
    @shipper_div = 'display:none;'
    @winery_div = 'display:none;'
  end
  
  def create
    @user = User.new(params[:user])
    @password = params[:password]
    confirm_password = params[:confirm_password]
    if @password == confirm_password
      @user.password = params[:password]
      if @user.save
        flash[:notice] = "User '#{@user.login}' successfully created."
        redirect_to users_path
      else
        render :action => 'new'
      end
    else
      flash[:notice] = "New and confirm passwords did not match, please try again."
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @shippers = Shipper.find(:all, :order => ["name ASC"])
    @wineries = Winery.find(:all, :order => ["name ASC"]).collect {|w| [w.name, w.id]}
    if @user.access == 'Winery'
      @shipper_div = 'display:none;'
      @winery_div = ''
    elsif @user.access == 'Carrier'
      @shipper_div = ''
      @winery_div = 'display:none;'
    end
  end
  
  def update
    @user = User.find(params[:id])
    @password = params[:password]
    if @user.update_attributes(params[:user])
      flash[:notice] = "User '#{@user.login}' successfully updated."
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User '#{@user.login}' permanently destroyed."
    else
      flash[:notice] = "There was an error deleting that user."
    end
    redirect_to users_path
  end
  
  private # -------------------------------------------------------
  
  def reject_unauthorized_users
    if @current_user.access != 'Global'
      flash[:notice] = "You do not have access to this function, you've been logged out."
      session[:user_id] = nil
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
end
