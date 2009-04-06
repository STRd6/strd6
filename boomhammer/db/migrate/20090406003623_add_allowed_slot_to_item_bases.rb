class AddAllowedSlotToItemBases < ActiveRecord::Migration
  def self.up
    add_column :item_bases, :allowed_slot, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :item_bases, :allowed_slot
  end
end
