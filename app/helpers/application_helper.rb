# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'state_select'
  
  def remove_zeros_from_date(marked_date_string)
    marked_date_string.gsub!('*0', '').gsub!('*', '')
  end
end
