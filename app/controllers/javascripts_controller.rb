class JavascriptsController < ApplicationController
  def dynamic_user_access
    @wineries = Winery.find(:all)
    @shippers = Shipper.find(:all)
  end
end
