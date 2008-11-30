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

ActiveRecord::Schema.define(:version => 20081123025443) do

  create_table "abilities", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "cost"
    t.string   "target_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.integer  "game_id",        :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "slot"
    t.integer  "card_data_id",   :null => false
    t.string   "card_data_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "hit_points",                    :null => false
    t.integer  "energy",                        :null => false
    t.integer  "actions",                       :null => false
    t.boolean  "spent",      :default => false, :null => false
    t.text     "base_stats",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_entries", :force => true do |t|
    t.integer  "player_id",  :null => false
    t.integer  "position",   :null => false
    t.integer  "game_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name",                         :null => false
    t.boolean  "public",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name",                          :null => false
    t.boolean  "secondary",  :default => false, :null => false
    t.integer  "base_uses"
    t.text     "stat_mods",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
