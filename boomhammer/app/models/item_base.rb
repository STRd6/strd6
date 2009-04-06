class ItemBase < ActiveRecord::Base
  include Named
  include Imageable

  serialize :granted_abilities

  has_many :items, :dependent => :destroy
  has_many :loots, :dependent => :destroy
  has_many :recipe_components, :dependent => :destroy
  has_many :recipe_outcomes, :dependent => :destroy

  validates_inclusion_of :allowed_slot, :in => Item::EquipSlots::ALL

  before_validation_on_create :configure_granted_abilities

  def spawn(attributes={})
    defaults = {}
    item = Item.new(attributes.reverse_merge!(defaults))
    items << item
    return item
  end

  def loot_entry(weight)
    Loot.new(:item_base => self, :weight => weight)
  end

  protected

  def configure_granted_abilities
    self.granted_abilities ||= []
  end
end
