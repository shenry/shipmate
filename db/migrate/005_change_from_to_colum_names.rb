class ChangeFromToColumNames < ActiveRecord::Migration
  def self.up
    remove_column :shipments, :from_winery
    add_column :shipments, :from_winery_id, :integer
    remove_column :shipments, :to_winery
    add_column :shipments, :to_winery_id, :integer
  end

  def self.down
  end
end
