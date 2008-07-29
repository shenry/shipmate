class Shipper < ActiveRecord::Base
  has_many :shipments
  has_many :users
  validates_uniqueness_of :name, :on => :create, :message => "already exists."
  validates_uniqueness_of :brief_name, :on => :create, :message => "has already been taken"
  validates_length_of :brief_name, :within => 3..8, :on => :create, :message => "must be between 3 and 8 characters"
  
  def before_save
    self.name.humanize
  end
end
