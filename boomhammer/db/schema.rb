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

ActiveRecord::Schema.define(:version => 20090503045622) do

  create_table "accounts", :force => true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.datetime "last_login",                                             :null => false
    t.integer  "total_logins",                            :default => 0, :null => false
    t.string   "referral_code",                                          :null => false
    t.integer  "referrer_id"
    t.integer  "energy",                                  :default => 0, :null => false
    t.integer  "offenses",                                :default => 0, :null => false
  end

  create_table "area_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "image_id"
    t.integer  "account_id"
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
    t.boolean  "starting_location", :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "region_id",                            :null => false
  end

  add_index "areas", ["region_id"], :name => "index_areas_on_region_id"

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
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "top",        :default => 0,  :null => false
    t.integer  "left",       :default => 0,  :null => false
    t.integer  "image_id"
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"
  add_index "characters", ["area_id"], :name => "index_characters_on_area_id"

  create_table "down_votes", :force => true do |t|
    t.integer  "votable_id",                      :null => false
    t.string   "votable_type",                    :null => false
    t.integer  "account_id",                      :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "converted",    :default => false, :null => false
  end

  add_index "down_votes", ["account_id", "votable_id", "votable_type"], :name => "index_down_votes_on_account_id_and_votable_id_and_votable_type", :unique => true
  add_index "down_votes", ["votable_id", "votable_type"], :name => "index_down_votes_on_votable_id_and_votable_type"

  create_table "event_bases", :force => true do |t|
    t.string   "name",                           :null => false
    t.integer  "image_id"
    t.string   "event_type", :default => "none", :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "owner_id",                  :null => false
    t.string   "owner_type",                :null => false
    t.integer  "base_id",                   :null => false
    t.string   "base_type",                 :null => false
    t.integer  "weight",     :default => 1, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "events", ["owner_id", "owner_type"], :name => "index_events_on_owner_id_and_owner_type"

  create_table "images", :force => true do |t|
    t.string   "file_name",                        :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "width",            :default => 32, :null => false
    t.integer  "height",           :default => 32, :null => false
    t.integer  "up_votes_count",   :default => 0,  :null => false
    t.integer  "down_votes_count", :default => 0,  :null => false
    t.integer  "account_id"
    t.integer  "up_rank",          :default => 0,  :null => false
    t.integer  "down_rank",        :default => 0,  :null => false
  end

  create_table "intrinsic_bases", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "image_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "intrinsic_bases", ["name"], :name => "index_intrinsics_on_name", :unique => true

  create_table "intrinsics", :force => true do |t|
    t.integer  "intrinsic_base_id", :null => false
    t.integer  "owner_id",          :null => false
    t.string   "owner_type",        :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "intrinsics", ["intrinsic_base_id", "owner_id", "owner_type"], :name => "index_intrinsics_on_intrinsic_base_id_and_owner_id_and_owner_type", :unique => true
  add_index "intrinsics", ["owner_id", "owner_type"], :name => "index_intrinsics_on_owner_id_and_owner_type"

  create_table "item_bases", :force => true do |t|
    t.string   "name",                                                      :null => false
    t.text     "description",                                               :null => false
    t.integer  "image_id"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "allowed_slot", :default => "Item::EquipSlot::Inventory",    :null => false
    t.integer  "account_id"
    t.string   "editability",  :default => "Editable::Editability::Public", :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "item_base_id",                                           :null => false
    t.integer  "quantity",     :default => 1,                            :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "slot",         :default => "Item::EquipSlot::Inventory", :null => false
    t.integer  "top",          :default => 0,                            :null => false
    t.integer  "left",         :default => 0,                            :null => false
  end

  add_index "items", ["owner_id", "owner_type"], :name => "index_items_on_owner_id_and_owner_type"

  create_table "knowledges", :force => true do |t|
    t.integer  "character_id", :null => false
    t.integer  "object_id",    :null => false
    t.string   "object_type",  :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "knowledges", ["character_id", "object_id", "object_type"], :name => "index_knowledges_on_character_id_and_object_id_and_object_type", :unique => true

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
    t.integer  "top",                 :default => 0, :null => false
    t.integer  "left",                :default => 0, :null => false
  end

  add_index "opportunities", ["area_id"], :name => "index_opportunities_on_area_id"

  create_table "opportunity_bases", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "image_id"
    t.integer  "account_id"
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
    t.integer  "account_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shop_items", :force => true do |t|
    t.integer  "price",      :null => false
    t.integer  "shop_id",    :null => false
    t.integer  "item_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shop_items", ["shop_id"], :name => "index_shop_items_on_shop_id"

  create_table "shops", :force => true do |t|
    t.integer  "character_id",                :null => false
    t.integer  "area_id",                     :null => false
    t.integer  "currency_id",                 :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "top",          :default => 0, :null => false
    t.integer  "left",         :default => 0, :null => false
    t.integer  "image_id"
  end

  add_index "shops", ["area_id"], :name => "index_shops_on_area_id"
  add_index "shops", ["character_id"], :name => "index_shops_on_character_id"

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

  create_table "up_votes", :force => true do |t|
    t.integer  "votable_id",                      :null => false
    t.string   "votable_type",                    :null => false
    t.integer  "account_id",                      :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "converted",    :default => false, :null => false
  end

  add_index "up_votes", ["account_id", "votable_id", "votable_type"], :name => "index_up_votes_on_account_id_and_votable_id_and_votable_type", :unique => true
  add_index "up_votes", ["votable_id", "votable_type"], :name => "index_up_votes_on_votable_id_and_votable_type"

end
