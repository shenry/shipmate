class Shipper < ActiveRecord::Base
  has_many :shipments
  
  validates_uniqueness_of :name, :on => :create, :message => "already exists."
end
