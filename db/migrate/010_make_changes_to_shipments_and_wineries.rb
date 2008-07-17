class MakeChangesToShipmentsAndWineries < ActiveRecord::Migration
  def self.up
    remove_column :shipments, :status
    add_column :shipments, :shipped?, :boolean, :default => false
    remove_column :wineries, :bond
    add_column :wineries, :bond, :string, :null => false, :default => ""
  end

  def self.down
    add_column :shipments, :status, :string
    remove_column :shipments, :shipped?
    remove_column :wineries, :bond
    add_column :wineries, :bond, :integer
  end
end
