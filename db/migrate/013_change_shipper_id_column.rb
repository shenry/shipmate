class ChangeShipperIdColumn < ActiveRecord::Migration
  def self.up
    remove_column :users, :shipper_id
    add_column :users, :shipper_id, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :shipper_id
    add_column :users, :shipper_id, :integer
  end
end
