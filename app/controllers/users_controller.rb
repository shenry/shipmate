class UsersController < ApplicationController
  before_filter :logged_in, :get_user, :reject_unauthorized_users

  def index
    @users = User.find(:all)
  end
  
  def find_access
    if params[:value] == 'Carrier'
      @value = 'Carrier'
      @shippers = Shipper.find(:all, :order => ["name ASC"])
      respond_to do |format|
        format.js
      end
    elsif params[:value] == 'Winery'
      @value = 'Winery'
      @wineries = Winery.find(:all, :order => ["name ASC"])
      respond_to do |format|
        format.js
      end
    else
      @value = 'nil'
    end
  end

  def new
    @user = User.new
    @shippers = Shipper.find(:all)
    @wineries = Winery.find(:all, :order => ["name ASC"])
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
  end
  
  def update
    @user = User.find(params[:id])
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
      redirect_to :controller => 'admin', :action => 'index'
      return false
    end
  end
end
