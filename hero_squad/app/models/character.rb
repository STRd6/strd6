class Character < ActiveRecord::Base
  module Slot
    ABILITY_1 = 1
    ABILITY_2 = 2
    ABILITY_3 = 3
    
    ABILITIES = [ABILITY_1, ABILITY_2, ABILITY_3]
    
    ITEM_PRIMARY = 4
    ITEM_SECONDARY = 5
  end
  
  has_one :primary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}, :include => :card_data
  has_one :secondary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}, :include => :card_data
  
  has_many :ability_cards, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ABILITIES}, :include => :card_data
  
  #alias_method :hp, :hit_points 
  #alias_method :en, :energy
  
  def dead?
    hit_points <= 0
  end
  
  def stats
    base_stats
  end
  
  def primary_item
    primary_item_card.card_data if primary_item_card
  end
  
  def secondary_item
    secondary_item_card.card_data if secondary_item_card
  end
  
  def abilities
    applied_abilities = ability_cards.inject({}) {|h, a| h[a.slot] = a.card_data}
    
    current_abilities = default_abilities.merge applied_abilities    
    
    return Slot::ABILITIES.map {|slot| current_abilities[slot]}.compact
  end
  
  def default_abilities
    {Slot::ABILITY_1 => :def1, Slot::ABILITY_2 => :def2, Slot::ABILITY_3 => :def3}
  end
end
