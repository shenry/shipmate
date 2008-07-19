class ChangeShippedColumn < ActiveRecord::Migration
  def self.up
    remove_column :shipments, :shipped?
    add_column :shipments, :is_shipped, :boolean, :null => false, :default => 0
  end

  def self.down
    remove_column :shipments, :is_shipped
    add_column :shipments, :shipped?, :boolean
  end
end
