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
  
  def get_detail(shipment)
    remote_function(:url      => shipment_path(shipment),
                    :method   => :get,
                    :loading  => "Element.show('spinner')",
                    :complete => "Element.hide('spinner')")
  end
  
  def hide_element
    update_page do |page|
      page.replace_html :cal_detail, ""
    end
  end
end
