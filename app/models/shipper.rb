class Shipper < ActiveRecord::Base
  has_many :shipments
  has_many :users
  validates_uniqueness_of :name, :on => :create, :message => "already exists."
end
