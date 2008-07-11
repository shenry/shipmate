class AddAccessCodesToUsers < ActiveRecord::Migration
  def self.up
    #remove_column :users, :access
    #add_column :users, :access, :string, :null => false, :default => ""
  end

  def self.down
    #remove_column :users, :access
  end
end
