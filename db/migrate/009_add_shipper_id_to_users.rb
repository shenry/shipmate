class AddShipperIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :shipper_id, :integer, :size => 3, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :shipper_id
  end
end
