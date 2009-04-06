class Character < ActiveRecord::Base
  include Named

  attr_accessor :intrinsic
  serialize :intrinsics

  belongs_to :account
  belongs_to :area

  has_many :items, :as => :owner, :dependent => :destroy
  has_many :equipped_items, :as => :owner, :conditions => {:slot => Item::EquipSlots::EQUIPPED}, :class_name => "Item"

  validates_presence_of :area
  validates_numericality_of :actions, :greater_than_or_equal_to => 0

  before_validation_on_create :assign_starting_area, 
    :set_default_intrinsics,
    :add_intrinsic

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:account_id => account_id}}}

  def net_abilities
    intrinsics.keys + granted_abilities
  end

  def granted_abilities
    equipped_items.inject([]) {|array, item| array + item.granted_abilities}
  end

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

  def take_opportunity(opportunity)
    perform(1) do |notifications|
      if (item_base = opportunity.explore)
        notifications[:got] = [add_item_from_base(item_base)]
      else
        notifications[:got] = []
      end
    end
  end

  def take_area_link(area_link)
    perform(1) do |notifications|
      self.area = area_link.linked_area
      notifications[:travelled] = area
    end
  end

  def make_recipe(recipe)
    perform(1) do |notifications|
      ingredient_component_pairs = recipe.recipe_components.map do |component|
        [
          items.first(:conditions =>
            ["quantity >= ? AND item_base_id = ?", component.quantity, component.item_base_id]
          ),
          component
        ]
      end

      missing_ingredient_pairs = ingredient_component_pairs.select do |pair|
        pair.first.nil?
      end

      if missing_ingredient_pairs.size > 0
        # Missing one or more ingredients...
        message = missing_ingredient_pairs.map do |pair|
          "#{pair.last}x#{pair.last.quantity}"
        end.join(' ')

        notifications[:status] = "Insufficient ingredients... Missing: " + message

      else
        ingredient_component_pairs.each do |pair|
          pair.first.quantity -= pair.last.quantity
          pair.first.save!
        end

        notifications[:got] = [add_item_from_base(recipe.generate_outcome_item_base)]
      end
    end
  end

  def daily_update
    self.actions = 50
    self.save
  end

  # Always returns the new item
  def add_item_from_base(item_base)
    # If we've got one of the same stack it!
    if (item = items.find_by_item_base_id(item_base.id))
      # TODO: Maybe check for secret differences, like enchants, or bustiness
      item.quantity += 1
      item.save!
    else
      item = item_base.spawn
      items << item
    end

    return item
  end

  protected

  def perform(action_cost)
    notifications = {}
    transaction do
      if (self.actions -= action_cost) >= 0
        yield notifications
        save!
      else
        notifications[:status] = "No actions remaining"
      end
    end
    return notifications
  end

  def assign_starting_area
    self.area ||= Area.random.starting.first
  end
  
  def set_default_intrinsics
    self.intrinsics ||= {}
  end

  def add_intrinsic
    if Intrinsic.legit?(intrinsic)
      intrinsics[intrinsic] = true
    end
  end
end
