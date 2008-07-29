class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :shipments, :ship_date
    add_index :wineries, :name
    add_index :shippers, :name
  end

  def self.down
    remove_index :shipments, :ship_date
    remove_index :wineries, :name
    add_index :shippers, :name
  end
end
