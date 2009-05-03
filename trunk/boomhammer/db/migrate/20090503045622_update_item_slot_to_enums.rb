class UpdateItemSlotToEnums < ActiveRecord::Migration
  def self.up
    change_column :items, :slot, :string, :null => false, :default => Item::EquipSlots::INVENTORY.to_s
    change_column :item_bases, :allowed_slot, :string, :null => false, :default => Item::EquipSlots::INVENTORY.to_s

#    ItemBase.reset_column_information
#
#    ItemBase.all.each do |item_base|
#      item_base.allowed_slot = Item::EquipSlots.values[item_base.allowed_slot.to_i]
#      item_base.save!
#    end
#
#    Item.all.each do |item|
#      item.slot = Item::EquipSlots.values[item.slot.to_i]
#      item.save!
#    end
  end

  def self.down
    change_column :item_bases, :allowed_slot, :integer, :null => false, :default => 0
    change_column :items, :slot, :integer, :null => false, :default => 0

#    ItemBase.all.each do |item_base|
#      item_base.allowed_slot = Item::EquipSlots.values.index(item_base.allowed_slot) || 0
#      item_base.save!
#    end
#
#    Item.all.each do |item|
#      item.slot = Item::EquipSlots.values.index(item.slot) || 0
#      item.save!
#    end
  end
end
