class Item < ActiveRecord::Base
  module EquipSlots
    INVENTORY = 0
    HEAD = 1
    TORSO = 2
    HANDS = 3
    LEGS = 4
    PET = 5

    EQUIPPED = [HEAD, TORSO, HANDS, LEGS, PET].freeze

    ALL = ([INVENTORY] + EQUIPPED).freeze

    NAME_FOR = {
      INVENTORY => "none",
      HEAD => "head",
      TORSO => "torso",
      HANDS => "hands",
      LEGS => "legs",
      PET => "pet",
    }
  end

  belongs_to :item_base
  belongs_to :owner, :polymorphic => true

  has_one :image, :through => :item_base

  has_many :shop_items, :dependent => :destroy

  validates_presence_of :item_base
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  validates_inclusion_of :slot, :in => EquipSlots::ALL

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
    EquipSlots::EQUIPPED.include? slot
  end

  # Returns an array suitable for collection select:
  # form.collection_select :field, Item.slot_select, :first, :last
  def self.slot_select
    EquipSlots::ALL.map {|slot| [slot, EquipSlots::NAME_FOR[slot]]}
  end
end
