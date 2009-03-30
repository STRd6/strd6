class Character < ActiveRecord::Base
  include Named

  attr_accessor :intrinsic

  serialize :intrinsics

  belongs_to :account
  belongs_to :area

  has_many :items, :as => :owner, :dependent => :destroy

  validates_presence_of :area
  validates_numericality_of :actions, :greater_than_or_equal_to => 0

  before_validation_on_create :assign_starting_area, :set_default_intrinsics, :add_intrinsic

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:account_id => account_id}}}

  def take_opportunity(opportunity)
    transaction do
      if actions > 0
        self.actions -= 1
        if (item_base = opportunity.explore)
          response = add_item_from_base(item_base)
        else
          response = "Found nothing"
        end
        save!
        return response
      else
        return "No actions remaining"
      end
    end
  end

  def take_area_link(area_link)
    transaction do
      if actions > 0
        self.actions -= 1
        self.area = area_link.linked_area
        save!
        return "Travelled to #{area}"
      else
        return "No actions remaining"
      end
    end
  end

  def make_recipe(recipe)
    transaction do
      if actions > 0
        self.actions -= 1

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
          return "Insufficient ingredients... Missing: " +
            missing_ingredient_pairs.map do |pair|
              "#{pair.last}x#{pair.last.quantity}"
            end.join(' ')
        else
          ingredient_component_pairs.each do |pair|
            pair.first.quantity -= pair.last.quantity
            pair.first.save!
          end

          result = add_item_from_base(recipe.generate_outcome_item_base)
          save!
          return result
        end
      else
        return "No actions remaining"
      end
    end
  end

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

    return "Got #{item}"
  end

  def assign_starting_area
    self.area = Area.random.starting.first
  end
  
  def set_default_intrinsics
    self.intrinsics ||= {}
  end

  def add_intrinsic
    intrinsics[intrinsic.to_sym] = true if intrinsic
  end
end
