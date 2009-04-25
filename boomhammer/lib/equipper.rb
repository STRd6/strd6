# Requires
#   perform
#   items
#
# Provides:
#   has_many :equipped_items
#   #equip
#   #can_equip?
#   #unequip
#   #unequip_slot
module Equipper
  def self.included(base)
    base.class_eval do
      has_many :equipped_items, :as => :owner, :conditions => {:slot => Item::EquipSlots::EQUIPPED}, :class_name => "Item"
      has_one :pet, :as => :owner, :class_name => "Item", :conditions => {:slot => Item::EquipSlots::PET}
    end
  end

  # Equips the given item in the give slot if possible,
  # returns notifications
  def equip(item, slot)
    return {:status => "Cannot equip #{item}"} unless can_equip?(item, slot)

    perform(1) do |notifications|
      unequip_slot(slot)

      item.slot = slot
      item.save!

      equipped_items.reload
      notifications[:status] = "Equipped #{item}"
    end
  end

  # True if can equip the given item in the given slot
  def can_equip?(item, slot)
    item.allowed_slot == slot && items.include?(item)
  end

  # Remove item from any slots it is in
  def unequip(item)
    return {:status => "Item not equipped"} unless item.equipped?

    perform(0) do |notifications|
      item.unequip!
      notifications[:status] = "Unequipped #{item}"
    end
  end

  # Remove from target slot any equipped item
  def unequip_slot(slot)
    if(equipped_item = equipped_items.first(:conditions => {:slot => slot}))
      equipped_item.unequip!
    else
      true
    end
  end
end
