# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'state_select'

  def remove_zeros_from_date(marked_date_string)
    new_string = marked_date_string.gsub('*0', '').gsub('*', '')
    return new_string
  end
  
  def toggle_value(object)
    remote_function(:url      => url_for(object),
                    :method   => :put,
                    :loading  => "Element.show('spinner-#{object.id}')",
                    :complete => "Element.hide('spinner-#{object.id}')",
                    :with     => "this.name + '=' + this.checked")
  end
  
  def get_winery_accessible_shipments(current_user, cutoff_date)
    user_wineries = current_user.wineries.collect {|c| c.id}
    @shipments = []
    winery_shipments = Shipment.find(:all, :order => ['ship_Date ASC'], 
                  :conditions => ["ship_date > ?", cutoff_date]).each do |shipment|
      if user_wineries.include?(shipment.to_winery_id) || user_wineries.include?(shipment.from_winery_id)
        @shipments << shipment
      end
    end
    return @shipments
  end
  
  def get_carrier_accessible_shipments(current_user, cutoff_date)
    @shipments = Shipment.find(:all, :order => ['ship_date ASC'], 
                  :conditions => ["ship_date > ? AND shipper_id = ?", cutoff_date, current_user.shipper_id])
  end
  
end
