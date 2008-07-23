class AddBriefCarrierNameToShippers < ActiveRecord::Migration
  def self.up
    add_column :shippers, :brief_name, :string, :limit => 8, :null => false, :default => ""
  end

  def self.down
    remove_column :shippers, :brief_name
  end
end
