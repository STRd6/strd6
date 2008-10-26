# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081026072109) do

  create_table "adjacencies", :force => true do |t|
    t.integer  "area_id"
    t.integer  "adjacent_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.text     "stats"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faction_id"
    t.integer  "area_id"
    t.integer  "energy",     :default => 0
    t.text     "resources"
    t.text     "properties"
  end

  create_table "display_data", :force => true do |t|
    t.integer  "top",              :default => 0, :null => false
    t.integer  "left",             :default => 0, :null => false
    t.integer  "z",                :default => 0, :null => false
    t.string   "image"
    t.integer  "displayable_id"
    t.string   "displayable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "display_data", ["displayable_id", "displayable_type"], :name => "index_display_data_on_displayable_id_and_displayable_type", :unique => true

  create_table "factions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.text     "properties"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "container_position", :default => 0
    t.text     "properties"
  end

  create_table "signs", :force => true do |t|
    t.string   "text"
    t.integer  "area_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "active_character_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "window_positions", :force => true do |t|
    t.string   "window"
    t.integer  "top"
    t.integer  "left"
    t.integer  "z"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "window_positions", ["window", "user_id"], :name => "index_window_positions_on_window_and_user_id", :unique => true

end
