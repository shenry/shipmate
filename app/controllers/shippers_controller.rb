class ShippersController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @shippers = Shipper.find(:all, :order => ["name ASC"])
  end

  def new
  end

  def edit
  end
end
