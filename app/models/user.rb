require 'digest/sha1'
class User < ActiveRecord::Base
  has_and_belongs_to_many :wineries
  belongs_to :shipper
  
  validates_inclusion_of :access, :in => ['Global', 'Carrier', 'Winery']
  validates_uniqueness_of :login
  validates_length_of :password, :within => 6..12, :on => :create, :message => " must be 6 to 12 characters long."
  
  attr_accessor :password, :confirm_password, :old_password
  attr_accessible :first_name, :last_name, :login, :email, :access
  
  def accessible_shipments
    case when self.access == 'Global'
      return Shipment.find(:all, :order => ["ship_date ASC"])
    when self.access == 'Winery'
      user_wineries = self.wineries.collect {|c| c.id}
      shipments = []
      winery_shipments = Shipment.find(:all, :order => ['ship_date ASC']).each do |shipment|
        if user_wineries.include?(shipment.to_winery_id) || user_wineries.include?(shipment.from_winery_id)
          shipments << shipment
        end
      end
      return shipments
    when self.access == 'Carrier'
      return Shipment.find(:all, :order => ["ship_date ASC"], :conditions => ["shipper_id = ?", self.shipper_id])
    end
  end
  
  def full_name
    self.first_name.humanize + ' ' + self.last_name.humanize
  end
  
  def before_save
    if self.access != 'Carrier'
      self.shipper_id = 0
    end
  end
  
  def before_create
    self.salt = User.make_salt(self.login.downcase)
    self.hashed_password = User.hash_with_salt(@password, self.salt)
  end
  
  def before_update
    unless @password.blank?
      self.salt = User.make_salt(self.login.downcase)
      self.hashed_password = User.hash_with_salt(@password, self.salt)
    end
  end
  
  def after_create
    @password = nil
  end
  
  def after_update
    @password = nil
  end
  
  def before_destroy
    if self.login == 'root'
      return false
    end
  end
  
  def self.authenticate(login = "", password = "")
    user = self.find(:first, :conditions => ["login = ?", login.downcase])
    return (user && user.authenticated?(password)) ? user : nil
  end
  
  def authenticated?(password)
    self.hashed_password == User.hash_with_salt(password, self.salt)
  end
  
  private #------------------------------------------------------------------
  
  def self.make_salt(string)
    return Digest::SHA1.hexdigest(string.to_s + Time.now.to_s)
  end
  
  def self.hash_with_salt(password, salt)
    return Digest::SHA1.hexdigest(salt + password)
  end
end
