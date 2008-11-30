class Character < ActiveRecord::Base
  module Slot
    ABILITY_1 = 1
    ABILITY_2 = 2
    ABILITY_3 = 3
    
    ABILITIES = [ABILITY_1, ABILITY_2, ABILITY_3]
    
    ITEM_PRIMARY = 4
    ITEM_SECONDARY = 5
  end
  
  STAT_ATTRIBUTES = [:str, :dex, :pow, :move, :max_hp, :max_en, :regen, :egen, :damage_received].freeze
  
  DEFAULT_ACTIONS = 2
  
  before_create :prepare_stats
  
  has_one :primary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}, :include => :data
  has_one :secondary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}, :include => :data
  
  has_many :ability_cards, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ABILITIES}, :include => :data
  
  #alias_method :hp, :hit_points 
  #alias_method :en, :energy
  
  def dead?
    hit_points <= 0
  end
  
  def stats
    base_stats
  end
  
  def primary_item
    primary_item_card.data if primary_item_card
  end
  
  def secondary_item
    secondary_item_card.data if secondary_item_card
  end
  
  def abilities
    applied_abilities = ability_cards.inject({}) {|h, a| h[a.slot] = a.card_data}
    
    current_abilities = default_abilities.merge applied_abilities    
    
    return Slot::ABILITIES.map {|slot| current_abilities[slot]}.compact
  end
  
  def default_abilities
    {Slot::ABILITY_1 => :def1, Slot::ABILITY_2 => :def2, Slot::ABILITY_3 => :def3}
  end
  
  # Define a method to access each modifiable stat attribute
  # These attributes may be modified by 
  STAT_ATTRIBUTES.each do |attr|
    if !respond_to? attr
      define_method attr do
        (base_stats[attr] or 0) + 
        ((primary_item.stat_mods[attr] if primary_item) or 0) +
        ((secondary_item.stat_mods[attr] if secondary_item) or 0)
      end
    else
      raise "Attempting to override an already defined method with stat attribute: #{attr}"
    end
  end
  
  def prepare_stats
    self.hit_points ||= max_hp
    self.energy ||= max_en
    self.actions ||= DEFAULT_ACTIONS
  end
end
