class WineriesController < ApplicationController
  before_filter :logged_in, :get_user

  def index
    @wineries = Winery.find(:all, :order => ["city ASC, name ASC"])
  end

  def new
  end

  def edit
  end
end
