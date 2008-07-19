class Shipment < ActiveRecord::Base
  belongs_to :shipper
  belongs_to :from_winery, :class_name => "Winery", :foreign_key => "from_winery_id"
  belongs_to :to_winery, :class_name => "Winery", :foreign_key => "to_winery_id"
  attr_accessor :new_from_winery_name, :new_to_winery_name
  
  validates_presence_of :from_winery_id, :on => :create, :message => "must be selected"
  validates_presence_of :to_winery_id, :on => :create, :message => "must be selected"
  validates_presence_of :ship_date, :on => :create, :message => "can't be blank"
  validates_presence_of :wine, :on => :create, :message => "can't be blank"
  #before_save :confirm_valid_wineries
  #
  #def confirm_valid_wineries
  #  if self.from_winery_id == self.to_winery_id
  #    return false
  #  end
  #end
end
