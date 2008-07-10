class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.integer :from_winery
      t.integer :to_winery
      t.string :wine,             :null => false, :default => ""
      t.integer :shipper_id
      t.date  :ship_date,         :null => false
      t.string :status,           :null => false, :default => "Pending"

      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end
