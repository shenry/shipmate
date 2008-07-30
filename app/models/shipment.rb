class Shipment < ActiveRecord::Base
  belongs_to :shipper
  belongs_to :from_winery, :class_name => "Winery", :foreign_key => "from_winery_id"
  belongs_to :to_winery, :class_name => "Winery", :foreign_key => "to_winery_id"
  attr_accessor :new_from_winery_name, :new_to_winery_name
  
  validates_presence_of :from_winery_id, :on => :create, :message => "must be selected"
  validates_presence_of :to_winery_id, :on => :create, :message => "must be selected"
  validates_presence_of :ship_date, :on => :create, :message => "can't be blank"
  validates_presence_of :wine, :on => :create, :message => "can't be blank"
  validates_inclusion_of :gals_per_load, :in => 1..7000, :on => :create, :message => "is invalid"
  
  before_create :confirm_valid_ship_date
   
  def confirm_valid_ship_date
    if self.ship_date < Time.now.to_date
      return false
    end
  end
end
