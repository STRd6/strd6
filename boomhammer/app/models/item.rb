class Item < ActiveRecord::Base
  enum :EquipSlots do
    INVENTORY("none")
    HEAD("head")
    TORSO("torso")
    HANDS("hands")
    LEGS("legs")
    PET("pet")

    attr_reader :display_name

    def init(display_name)
      @display_name = display_name
    end

    def self.equipable_slots
      [EquipSlots::HEAD, EquipSlots::TORSO, EquipSlots::HANDS, EquipSlots::LEGS, EquipSlots::PET].map(&:to_s)
    end
  end

  belongs_to :item_base
  belongs_to :owner, :polymorphic => true

  has_one :image, :through => :item_base

  has_many :shop_items, :dependent => :destroy

  constantize_attribute :slot

  validates_presence_of :item_base
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  validates_inclusion_of :slot, :in => EquipSlots.values

  delegate :name, 
    :description,
    :granted_abilities,
    :allowed_slot,
    :allowed_slot_name,
    :to => :item_base

  def to_s
    if equipped?
      "#{name}(#{allowed_slot_name})"
    else
      name
    end
  end

  # Remove item from any slots it is in and call `save!`
  def unequip!
    self.slot = EquipSlots::INVENTORY
    self.save!
  end

  # True if this item is currently equipped
  def equipped?
    EquipSlots.equipable_slots.include? slot
  end

  # Returns an array suitable for collection select:
  # form.collection_select :field, Item.slot_select, :first, :last
  def self.slot_select
    EquipSlots::values.map {|slot| [slot, slot.name]}
  end
end
