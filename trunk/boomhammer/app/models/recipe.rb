class Recipe < ActiveRecord::Base
  include Named
  include RandomScope
  include Eventful

  belongs_to :account

  has_many :recipe_components, :dependent => :destroy

  accepts_nested_attributes_for :recipe_components, :allow_destroy => true, 
    :reject_if => proc {|attributes| attributes['quantity'].to_i <= 0}

  def add_component(item_base, quantity=1, consume_percentage=100)
    recipe_components.build :item_base => item_base,
      :quantity => quantity,
      :consume_percentage => consume_percentage,
      :recipe => self
  end

  def shop_recipe?
    events.first.shop_event?
  end

  def ingredient_component_pairs(items)
    return recipe_components.map do |component|
      [
        items.first(:conditions =>
          ["quantity >= ? AND item_base_id = ?", component.quantity, component.item_base_id]
        ),
        component
      ]
    end
  end

  def missing_ingredients(items)
    return ingredient_component_pairs(items).select do |pair|
      pair.first.nil?
    end
  end

  def make(character, notifications, params)
    component_pairs = ingredient_component_pairs(character.items)

    missing_ingredient_pairs = component_pairs.select do |pair|
      pair.first.nil?
    end

    if missing_ingredient_pairs.size > 0
      # Missing one or more ingredients...
      message = missing_ingredient_pairs.map do |pair|
        "#{pair.last}x#{pair.last.quantity}"
      end.join(' ')

      notifications[:status] = "Insufficient ingredients... Missing: " + message
    else
      component_pairs.each do |pair|
        pair.first.quantity -= pair.last.quantity if pair.last.consume?
        pair.first.save!
      end

      notifications.merge! generate_event.perform(character, params)
    end
  end

  def self.auto_build(name, components_hash, events_hash)
    recipe = Recipe.new :name => name

    components_hash.each do |item_base, quantity|
      recipe.add_component(item_base, quantity || 1)
    end

    events_hash.each do |base, weight|
      recipe.add_event(base, weight)
    end

    recipe.save!
    
    return recipe
  end
end
