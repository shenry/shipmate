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
    %w( A B C ).each_with_index do |w, i|
      a = Winery.create(:name => "Winery #{w}", :bond => 1000 + i, :address_line_1 => "#{w} St. ##{i}", :city => "#{w} City", :state => "CA", :zip => "94558" )
    end
  end

  def self.down
    drop_table :wineries
  end
end
