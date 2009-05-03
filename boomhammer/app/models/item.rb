class Item < ActiveRecord::Base
  enum :EquipSlot do
    Inventory("none")
    Head("head")
    Torso("torso")
    Hands("hands")
    Legs("legs")
    Pet("pet")

    attr_reader :display_name

    def init(display_name)
      @display_name = display_name
    end

    def self.default_string
      values.first.to_s
    end

    def self.equipable_slots
      [EquipSlot::Head, EquipSlot::Torso, EquipSlot::Hands, EquipSlot::Legs, EquipSlot::Pet]
    end

    def self.equipable_slot_strings
      equipable_slots.map(&:to_s)
    end
  end

  belongs_to :item_base
  belongs_to :owner, :polymorphic => true

  has_one :image, :through => :item_base

  has_many :shop_items, :dependent => :destroy

  constantize_attribute :slot

  validates_presence_of :item_base
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  validates_inclusion_of :slot, :in => EquipSlot.values

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
    self.slot = EquipSlot::Inventory
    self.save!
  end

  # True if this item is currently equipped
  def equipped?
    EquipSlot.equipable_slots.include? slot
  end
end
