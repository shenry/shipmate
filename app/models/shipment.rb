class Shipment < ActiveRecord::Base
  belongs_to :shipper
  belongs_to :from_winery, :class_name => "Winery", :foreign_key => "from_winery_id"
  belongs_to :to_winery, :class_name => "Winery", :foreign_key => "to_winery_id"
end
