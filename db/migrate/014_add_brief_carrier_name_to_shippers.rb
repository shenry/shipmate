class AddBriefCarrierNameToShippers < ActiveRecord::Migration
  def self.up
    add_column :shippers, :brief_name, :string, :limit => 8, :null => false, :default => ""
    Shipper.find(:all).each do |s|
      s.brief_name = s.name.slice(0..7)
      s.save
    end
  end

  def self.down
    remove_column :shippers, :brief_name
  end
end
