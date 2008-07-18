class AddShippeIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :shipper_id, :integer
    
    User.find(:all).each do |user|
      if user.access == 'Carrier'
        user.shipper_id = 1
        user.save
      end
    end
  end

  def self.down
    remove_column :users, :shipper_id
  end
end
