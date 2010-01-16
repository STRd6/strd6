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

ActiveRecord::Schema.define(:version => 20091220213943) do

  create_table "commands", :force => true do |t|
    t.integer  "player_id",    :null => false
    t.string   "state",        :null => false
    t.string   "command_type", :null => false
    t.integer  "x",            :null => false
    t.integer  "y",            :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "commands", ["player_id"], :name => "index_commands_on_player_id"

  create_table "houses", :force => true do |t|
    t.integer  "treeworld_id", :null => false
    t.integer  "owner_id",     :null => false
    t.integer  "x",            :null => false
    t.integer  "y",            :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "houses", ["treeworld_id"], :name => "index_houses_on_treeworld_id"

  create_table "players", :force => true do |t|
    t.integer  "treeworld_id", :null => false
    t.string   "name"
    t.integer  "x",            :null => false
    t.integer  "y",            :null => false
    t.text     "path",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "players", ["treeworld_id"], :name => "index_players_on_treeworld_id"

  create_table "trees", :force => true do |t|
    t.integer  "treeworld_id",                :null => false
    t.integer  "x",                           :null => false
    t.integer  "y",                           :null => false
    t.integer  "planted_at",   :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "trees", ["treeworld_id"], :name => "index_trees_on_treeworld_id"

  create_table "treeworlds", :force => true do |t|
    t.integer  "width",      :default => 32, :null => false
    t.integer  "height",     :default => 32, :null => false
    t.integer  "age",        :default => 0,  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "walls", :force => true do |t|
    t.integer  "treeworld_id", :null => false
    t.integer  "x",            :null => false
    t.integer  "y",            :null => false
    t.boolean  "vertical",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "walls", ["treeworld_id"], :name => "index_walls_on_treeworld_id"
  add_index "walls", ["x", "y", "vertical"], :name => "index_walls_on_x_and_y_and_vertical", :unique => true

end
