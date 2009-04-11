class Character < ActiveRecord::Base
  include Named
  include Equipper

  attr_accessor :intrinsic_base_id

  belongs_to :account
  belongs_to :area

  has_many :intrinsics, :as => :owner, :dependent => :destroy
  has_many :items, :as => :owner, :dependent => :destroy

  has_many :knowledges, :dependent => :destroy

  validates_presence_of :area
  validates_numericality_of :actions, :greater_than_or_equal_to => 0

  before_validation_on_create :assign_starting_area

  before_validation :add_intrinsic

  after_create :add_knowledge_of_current_area

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:account_id => account_id}}}

  def net_abilities
    intrinsics + granted_abilities
  end

  def granted_abilities
    equipped_items.inject([]) {|array, item| array + item.granted_abilities}
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
      add_knowledge_of_current_area
      notifications[:travelled] = area
    end
  end

  def make_recipe(recipe)
    #return unless has_knowledge recipe

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
          pair.first.quantity -= pair.last.quantity if pair.last.consume?
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
    add_knowledge(item_base)

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

  def add_knowledge(object)
    knowledges.find_or_create_by_object_id_and_object_type(object.id, object.class.name)
  end

  def has_knowledge(object)
    knowledges.find_by_object_id_and_object_type(object.id, object.class.name)
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

  def add_knowledge_of_current_area
    add_knowledge area

    area.opportunities.each do |opportunity|
      add_knowledge opportunity if opportunity.can_be_discovered_by? self
    end

    area.area_links.each do |area_link|
      add_knowledge area_link if area_link.can_be_discovered_by? self
    end
  end

  def add_intrinsic
    unless intrinsic_base_id.nil?
      intrinsics.build :intrinsic_base_id => intrinsic_base_id unless intrinsics.map(&:intrinsic_base_id).include? intrinsic_base_id.to_i
    end
  end
end
