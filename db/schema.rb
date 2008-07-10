# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "shipments", :force => true do |t|
    t.string   "wine",                          :default => "",        :null => false
    t.integer  "shipper_id",                    :default => 0
    t.date     "ship_date",                                            :null => false
    t.string   "status",                        :default => "Pending", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loads",          :limit => 2,   :default => 1,         :null => false
    t.integer  "gals_per_load",  :limit => 4,   :default => 6500,      :null => false
    t.text     "comments",       :limit => 100, :default => "",        :null => false
    t.integer  "from_winery_id"
    t.integer  "to_winery_id"
  end

  create_table "shippers", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wineries", :force => true do |t|
    t.string   "name",           :limit => 25, :default => "", :null => false
    t.integer  "bond",                         :default => 0,  :null => false
    t.string   "address_line_1",               :default => "", :null => false
    t.string   "address_line_2",               :default => "", :null => false
    t.string   "city",                         :default => "", :null => false
    t.string   "state",          :limit => 2,                  :null => false
    t.string   "zip",            :limit => 5,                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
