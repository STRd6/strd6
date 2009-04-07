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

ActiveRecord::Schema.define(:version => 20090407010623) do

  create_table "accounts", :force => true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
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
    t.text     "requisites",     :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "area_links", ["area_id"], :name => "index_area_links_on_area_id"

  create_table "areas", :force => true do |t|
    t.integer  "area_base_id"
    t.string   "name"
    t.boolean  "starting_location", :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "badge_bases", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "description",     :null => false
    t.string   "image_file_name", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "badges", :force => true do |t|
    t.integer  "owner_id",                     :null => false
    t.string   "owner_type",                   :null => false
    t.integer  "badge_base_id",                :null => false
    t.integer  "quantity",      :default => 1, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "badges", ["owner_id", "owner_type"], :name => "index_badges_on_owner_id_and_owner_type"

  create_table "characters", :force => true do |t|
    t.integer  "account_id",                 :null => false
    t.string   "name",                       :null => false
    t.integer  "area_id",                    :null => false
    t.integer  "actions",    :default => 50, :null => false
    t.text     "intrinsics",                 :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"
  add_index "characters", ["area_id"], :name => "index_characters_on_area_id"

  create_table "images", :force => true do |t|
    t.string   "file_name",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "intrinsics", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "image_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "intrinsics", ["name"], :name => "index_intrinsics_on_name", :unique => true

  create_table "item_bases", :force => true do |t|
    t.string   "name",                             :null => false
    t.text     "description",                      :null => false
    t.integer  "image_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "granted_abilities",                :null => false
    t.integer  "allowed_slot",      :default => 0, :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "item_base_id",                :null => false
    t.integer  "quantity",     :default => 1, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "slot",         :default => 0, :null => false
  end

  add_index "items", ["owner_id", "owner_type"], :name => "index_items_on_owner_id_and_owner_type"

  create_table "logins", :force => true do |t|
    t.integer  "account_id",   :null => false
    t.string   "identity_url", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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
    t.integer  "opportunity_base_id",                :null => false
    t.integer  "area_id",                            :null => false
    t.integer  "depletion",           :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "opportunities", ["area_id"], :name => "index_opportunities_on_area_id"

  create_table "opportunity_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.text     "requisites",  :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "recipe_components", :force => true do |t|
    t.integer  "recipe_id",                           :null => false
    t.integer  "item_base_id",                        :null => false
    t.integer  "quantity",           :default => 1,   :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "consume_percentage", :default => 100, :null => false
  end

  create_table "recipe_outcomes", :force => true do |t|
    t.integer  "recipe_id",                   :null => false
    t.integer  "item_base_id",                :null => false
    t.integer  "weight",       :default => 1, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "recipe_outcomes", ["recipe_id", "weight"], :name => "index_recipe_outcomes_on_recipe_id_and_weight"

  create_table "recipes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
