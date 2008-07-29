class UsersController < ApplicationController
  before_filter :logged_in, :get_user, :allow_only_global_access

  def index
    @users = User.find(:all)
  end
  
  def show
    @user = User.find(session[:user_id])
  end
  
  def find_access
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
    prepare_user_access_attributes
    @shipper_div = 'display:none;'
    @winery_div = 'display:none;'
  end
  
  def create
    @user = User.new(params[:user])
    @password = params[:password]
    confirm_password = params[:confirm_password]
    wineries = params[:wineries]
    if @password == confirm_password
      @user.password = params[:password]
      if @user.save
        if @user.access == 'Winery'
          wineries.each do |w|
            @user.wineries << Winery.find(w)
          end
        end
        flash[:notice] = "User '#{@user.login}' successfully created."
        redirect_to users_path
      else
        prepare_access_divs
        prepare_user_access_attributes
        render :action => 'new'
      end
    else
      flash[:notice] = "New and confirm passwords did not match, please try again."
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    prepare_user_access_attributes
    prepare_access_divs
  end
  
  def update
    @user = User.find(params[:id])
    @password = params[:password]
    if @user.update_attributes(params[:user])
        if @user.access == 'Winery'
        checked_wineries = params[:wineries]
        @user.wineries = []
        checked_wineries.each do |w|
          @user.wineries << Winery.find(w)
        end
      end
      flash[:notice] = "User '#{@user.login}' successfully updated."
      redirect_to users_path
    else
      prepare_access_divs
      prepare_user_access_attributes
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
    
  def prepare_user_access_attributes
    @shippers = Shipper.find(:all, :order => ["name ASC"])
    @wineries = Winery.find(:all, :order => ["name ASC"]).collect {|w| [w.name, w.id]}
  end
  
  def prepare_access_divs
    if @user.access == 'Winery'
      @shipper_div = 'display:none;'
      @winery_div = ''
    elsif @user.access == 'Carrier'
      @shipper_div = ''
      @winery_div = 'display:none;'
    end
  end
end
