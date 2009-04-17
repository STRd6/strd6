class AddAccountToModels < ActiveRecord::Migration
  def self.up
    add_column :area_bases, :account_id, :integer
    add_column :item_bases, :account_id, :integer
    add_column :opportunity_bases, :account_id, :integer
    add_column :recipes, :account_id, :integer
  end

  def self.down
    remove_column :recipes, :account_id
    remove_column :opportunity_bases, :account_id
    remove_column :item_bases, :account_id
    remove_column :area_bases, :account_id
  end
end
