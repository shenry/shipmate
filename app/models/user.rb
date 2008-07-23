require 'digest/sha1'
class User < ActiveRecord::Base
  has_and_belongs_to_many :wineries
  belongs_to :shipper
  
  validates_inclusion_of :access, :in => ['Global', 'Carrier', 'Winery']
  validates_uniqueness_of :login
  validates_length_of :password, :within => 6..12, :on => :create, :message => " must be 6 to 12 characters long."
  
  attr_accessor :password, :confirm_password, :old_password
  attr_accessible :first_name, :last_name, :login, :email
  attr_protected :hashed_password, :salt
  
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
