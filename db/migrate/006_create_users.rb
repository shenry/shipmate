class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login,            :limit => 18, :null => false, :default => ""
      t.string :hashed_password,  :limit => 40, :null => false, :default => ""
      t.string :salt,             :limit => 40
      t.string :email,            :limit => 25, :null => false, :default => ""
      t.string :first_name,       :limit => 14, :null => false, :default => ""
      t.string :last_name,        :limit => 18, :null => false, :default => ""
      t.string :access,                         :null => false, :default => ""

      t.timestamps
    end
    
    User.create :login => 'root', :password => 'SpqrPadova', :first_name => 'root', :last_name => 'user', :access => 'Global'
    
  end

  def self.down
    drop_table :users
  end
end
