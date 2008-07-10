class AddLoadsToShipment < ActiveRecord::Migration
  def self.up
    add_column :shipments, :loads, :integer, :limit => 2, :null => false, :default => 1
    add_column :shipments, :gals_per_load, :integer, :limit => 4, :null => false, :default => 6500
    add_column :shipments, :comments, :text, :limit => 100, :null => false, :default => ""
  end

  def self.down
    remove_column :shipments, :loads
    remove_column :shipments, :gals_per_load
    remove_column :shipments, :comments
  end
end
