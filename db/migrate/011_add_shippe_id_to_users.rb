class AddShippeIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :shipper_id, :integer
  end

  def self.down
    remove_column :users, :shipper_id
  end
end
