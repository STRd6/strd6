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

ActiveRecord::Schema.define(:version => 20090128032024) do

  create_table "abilities", :force => true do |t|
    t.string   "name",                                     :null => false
    t.boolean  "activated",             :default => false, :null => false
    t.text     "attribute_expressions"
    t.text     "stat_mods",                                :null => false
    t.string   "target_type",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abilities", ["name"], :name => "index_abilities_on_name", :unique => true

  create_table "cards", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "slot"
    t.integer  "data_id",    :null => false
    t.string   "data_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["game_id", "owner_id", "owner_type"], :name => "index_cards_on_game_id_and_owner_id_and_owner_type"

  create_table "character_instances", :force => true do |t|
    t.integer  "character_id",                            :null => false
    t.integer  "player_id",                               :null => false
    t.integer  "game_id",                                 :null => false
    t.integer  "default_ability_1_id"
    t.integer  "default_ability_2_id"
    t.integer  "default_ability_3_id"
    t.integer  "hit_points",                              :null => false
    t.integer  "energy",                                  :null => false
    t.integer  "actions",                                 :null => false
    t.boolean  "spent",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
  end

  create_table "characters", :force => true do |t|
    t.string   "name",                 :null => false
    t.integer  "default_ability_1_id"
    t.integer  "default_ability_2_id"
    t.integer  "default_ability_3_id"
    t.text     "base_stats",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["name"], :name => "index_characters_on_name", :unique => true

  create_table "game_entries", :force => true do |t|
    t.integer  "player_id",  :null => false
    t.integer  "position",   :null => false
    t.integer  "game_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_entries", ["game_id", "position"], :name => "index_game_entries_on_game_id_and_position", :unique => true
  add_index "game_entries", ["player_id", "game_id"], :name => "index_game_entries_on_player_id_and_game_id", :unique => true

  create_table "games", :force => true do |t|
    t.string   "name",                               :null => false
    t.boolean  "public",           :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phase"
    t.integer  "active_player"
    t.integer  "active_character"
  end

  add_index "games", ["name"], :name => "index_games_on_name"

  create_table "items", :force => true do |t|
    t.string   "name",                          :null => false
    t.boolean  "secondary",  :default => false, :null => false
    t.integer  "base_uses"
    t.text     "stat_mods",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["name"], :name => "index_items_on_name", :unique => true

  create_table "players", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["name"], :name => "index_players_on_name", :unique => true

end
