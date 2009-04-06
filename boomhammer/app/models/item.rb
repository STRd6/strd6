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

  include Named

  belongs_to :item_base
  belongs_to :owner, :polymorphic => true

  has_many :items, :dependent => :destroy

  validates_presence_of :item_base
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  validates_inclusion_of :slot, :in => EquipSlots::ALL

  delegate :name, :to => :item_base
  delegate :description, :to => :item_base
  delegate :image_file_name, :to => :item_base
  delegate :granted_abilities, :to => :item_base
  delegate :allowed_slot, :to => :item_base

  def allowed_slot_name
    EquipSlots::NAME_FOR[allowed_slot]
  end

  def self.slot_select
    EquipSlots::ALL.map {|slot| [slot, EquipSlots::NAME_FOR[slot]]}
  end
end
