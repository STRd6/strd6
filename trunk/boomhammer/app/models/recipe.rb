class Recipe < ActiveRecord::Base
  include Named
  include Eventful

  has_many :recipe_components, :dependent => :destroy

  accepts_nested_attributes_for :recipe_components, :allow_destroy => true, 
    :reject_if => proc {|attributes| attributes['quantity'].to_i <= 0}

  def add_component(item_base, quantity=1, consume_percentage=100)
    recipe_components.build :item_base => item_base,
      :quantity => quantity,
      :consume_percentage => consume_percentage,
      :recipe => self
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
