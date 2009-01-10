class CreateShippers < ActiveRecord::Migration
  def self.up
    create_table :shippers do |t|
      t.string :name,     :null => false, :defualt => ""
      t.timestamps
    end
    %w( X Y Z ).each do |s|
      Shipper.create(:name => "#{s} Hauling")
    end
  end

  def self.down
    drop_table :shippers
  end
end
