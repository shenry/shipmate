class Winery < ActiveRecord::Base
  has_many :to_shipments, :class_name => "Shipment", :foreign_key => "to_winery_id"
  has_many :from_shipments, :class_name => "Shipment", :foreign_key => "from_winery_id"
  has_and_belongs_to_many :users
  
  validates_length_of :name, :within => 3..25, :on => :save, :message => "must be less than 25 characters."
  validates_numericality_of :bond, :on => :save, :message => " must be a number."
  validates_presence_of :name, :on => :save, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :save, :message => " already exists."
  validates_presence_of :address_line_1, :on => :save, :message => "can't be blank"
  validates_presence_of :city, :on => :save, :message => "can't be blank"
  validates_format_of :zip, :with => /\A[0-9]+\Z/, :on => :save
  validates_length_of :zip, :is => 5, :on => :save, :message => "must be 5 digits"
  
  def mailing_address
    return self.address_line_1 + (self.address_line_2.blank? ? '<br />' : "#{self.address_line_2}<br />") + self.city + ', ' + self.state + ' ' + self.zip
  end
  
  def before_save
    self.name.humanize
    self.address_line_1.humanize
    self.address_line_2.humanize
  end
end
