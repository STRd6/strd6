class Recipe < ActiveRecord::Base
  include Named

  has_many :recipe_components, :dependent => :destroy
  has_many :recipe_outcomes, :order => "weight DESC", :dependent => :destroy

  accepts_nested_attributes_for :recipe_components, :allow_destroy => true, 
    :reject_if => proc {|attributes| attributes['quantity'].to_i <= 0}
  accepts_nested_attributes_for :recipe_outcomes, :allow_destroy => true,
    :reject_if => proc {|attributes| attributes['weight'].to_i <= 0}

  def generate_outcome_item_base
    total_weight = recipe_outcomes.all.sum(&:weight)

    roll = rand(total_weight)

    recipe_outcomes.each do |outcome|
      return outcome.item_base if roll <= 0
      roll -= outcome.weight
    end

    return recipe_outcomes.last.item_base
  end

  def add_component(item_base, quantity=1)
    recipe_components.build :item_base => item_base, :quantity => quantity, :recipe => self
  end

  def add_outcome(item_base, weight=1)
    recipe_outcomes.build :item_base => item_base, :weight => weight, :recipe => self
  end

  def self.auto_build(name, components_hash, outcomes_hash)
    recipe = Recipe.new :name => name

    components_hash.each do |item_base, quantity|
      recipe.add_component(item_base, quantity || 1)
    end

    outcomes_hash.each do |item_base, weight|
      recipe.add_outcome(item_base, weight)
    end

    recipe.save!
    
    return recipe
  end
end
