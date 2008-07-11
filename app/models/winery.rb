class Winery < ActiveRecord::Base
  has_many :to_shipments, :class_name => "Shipment", :foreign_key => "to_winery_id"
  has_many :from_shipments, :class_name => "Shipment", :foreign_key => "from_winery_id"
  has_and_belongs_to_many :users
  
  validates_uniqueness_of :bond, :on => :create, :message => " already exists."
  validates_uniqueness_of :name, :on => :create, :message => " already exists."
  validates_numericality_of :bond, :on => :create, :message => " must be a number."
end
