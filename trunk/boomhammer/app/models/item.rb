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
end
