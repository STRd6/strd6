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

ActiveRecord::Schema.define(:version => 20090327030912) do

  create_table "accounts", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "area_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "area_links", :force => true do |t|
    t.integer  "area_id",        :null => false
    t.integer  "linked_area_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "area_links", ["area_id"], :name => "index_area_links_on_area_id"

  create_table "areas", :force => true do |t|
    t.integer  "area_base_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "item_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "item_base_id", :null => false
    t.integer  "quantity",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "items", ["owner_id", "owner_type"], :name => "index_items_on_owner_id_and_owner_type"

  create_table "logins", :force => true do |t|
    t.integer  "account_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "loots", :force => true do |t|
    t.integer  "opportunity_base_id", :null => false
    t.integer  "item_base_id",        :null => false
    t.integer  "weight",              :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "loots", ["opportunity_base_id", "weight"], :name => "index_loots_on_opportunity_base_id_and_weight"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "opportunities", :force => true do |t|
    t.integer  "opportunity_base_id", :null => false
    t.integer  "area_id",             :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "opportunities", ["area_id"], :name => "index_opportunities_on_area_id"

  create_table "opportunity_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "players", :force => true do |t|
    t.integer  "account_id",    :null => false
    t.string   "name",          :null => false
    t.integer  "location_id"
    t.string   "location_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "players", ["account_id"], :name => "index_players_on_account_id"
  add_index "players", ["location_id", "location_type"], :name => "index_players_on_location_id_and_location_type"

  create_table "recipe_components", :force => true do |t|
    t.integer  "recipe_id",    :null => false
    t.integer  "item_base_id", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "recipe_outcomes", :force => true do |t|
    t.integer  "recipe_id",    :null => false
    t.integer  "item_base_id", :null => false
    t.integer  "weight",       :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "recipe_outcomes", ["recipe_id", "weight"], :name => "index_recipe_outcomes_on_recipe_id_and_weight"

  create_table "recipes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
