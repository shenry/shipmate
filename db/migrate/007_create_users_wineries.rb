class CreateUsersWineries < ActiveRecord::Migration
  def self.up
    create_table :users_wineries, :id => false do |t|
      t.integer :winery_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users_wineries
  end
end
