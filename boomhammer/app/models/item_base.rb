class ItemBase < ActiveRecord::Base
  include Named

  belongs_to :account
  belongs_to :image

  has_many :granted_abilities, :class_name => "Intrinsic", :as => :owner, :dependent => :destroy

  has_many :items, :dependent => :destroy
  has_many :loots, :dependent => :destroy
  has_many :recipe_components, :dependent => :destroy
  has_many :recipe_outcomes, :dependent => :destroy

  validates_inclusion_of :allowed_slot, :in => Item::EquipSlots::ALL

  before_save :save_new_granted_abilities

  def spawn(attributes={})
    defaults = {}
    item = Item.new(attributes.reverse_merge!(defaults))
    items << item
    return item
  end

  def loot_entry(weight)
    Loot.new(:item_base => self, :weight => weight)
  end

  def intrinsic_base_ids
    granted_abilities.map(&:intrinsic_base_id)
  end

  def intrinsic_base_ids=(ids)
    @intrinsic_base_ids = ids
  end

  # The string name for this item's allowed slot
  def allowed_slot_name
    Item::EquipSlots::NAME_FOR[allowed_slot]
  end

  protected
  def save_new_granted_abilities
    if @intrinsic_base_ids
      existing_ids, new_ids = @intrinsic_base_ids.partition {|id| intrinsic_base_ids.include? id }

      # Delete the old ones
      granted_abilities.each do |requisite|
        requisite.destroy unless existing_ids.include? requisite.intrinsic_base_id
      end

      # Add the new ones
      new_ids.each do |id|
        granted_abilities.build :intrinsic_base_id => id
      end
    end
  end
end
