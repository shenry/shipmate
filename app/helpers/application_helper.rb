# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'state_select'
  
  def remove_zeros_from_date(marked_date_string)
    marked_date_string.gsub!('*0', '').gsub!('*', '')
  end
  
  def toggle_value(object)
    remote_function(:url      => url_for(object),
                    :method   => :put,
                    :loading  => "Element.show('spinner-#{object.id}')",
                    :complete => "Element.hide('spinner-#{object.id}')",
                    :with     => "this.name + '=' + this.checked")
  end
end
