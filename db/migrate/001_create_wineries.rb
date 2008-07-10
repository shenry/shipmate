class CreateWineries < ActiveRecord::Migration
  def self.up
    create_table :wineries do |t|
      t.string :name,           :limit => 25, :null => false, :default => ""
      t.integer :bond,                        :null => false, :default => 0
      t.string :address_line_1,               :null => false, :default => ""
      t.string :address_line_2,               :null => false, :default => ""
      t.string :city,                         :null => false, :default => ""
      t.string :state,          :limit => 2,  :null => false, :defualt => ""
      t.string :zip,            :limit => 5,  :null => false, :defualt => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :wineries
  end
end
