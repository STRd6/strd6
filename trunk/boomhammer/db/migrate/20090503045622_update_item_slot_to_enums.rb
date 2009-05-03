class UpdateItemSlotToEnums < ActiveRecord::Migration
  def self.up
    default = Item::EquipSlot.default_string

    change_column :items, :slot, :string, :null => false, :default => default
    change_column :item_bases, :allowed_slot, :string, :null => false, :default => default

    ItemBase.reset_column_information

    ItemBase.all.each do |item_base|
      item_base.allowed_slot = Item::EquipSlot.values[item_base.allowed_slot_before_type_cast.to_i]
      item_base.save!
    end

    Item.all.each do |item|
      item.slot = Item::EquipSlot.values[item.slot_before_type_cast.to_i]
      item.save!
    end
  end

  def self.down
    change_column :item_bases, :allowed_slot, :integer, :null => false, :default => 0
    change_column :items, :slot, :integer, :null => false, :default => 0

    ItemBase.all.each do |item_base|
      item_base.allowed_slot = Item::EquipSlot.values.index(item_base.allowed_slot) || 0
      item_base.save!
    end

    Item.all.each do |item|
      item.slot = Item::EquipSlot.values.index(item.slot) || 0
      item.save!
    end
  end
end
