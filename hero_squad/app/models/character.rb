class Character < ActiveRecord::Base
  module Slot
    ABILITY_1 = 1
    ABILITY_2 = 2
    ABILITY_3 = 3
    
    ITEM_PRIMARY = 4
    ITEM_SECONDARY = 5
  end
  
  has_one :primary_item, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}
  has_one :secondary_item, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}
  
  has_many :abilities, :class_name => 'Card', :as => :owner
  
  #alias_method :hp, :hit_points 
  #alias_method :en, :energy
  
  def dead?
    hit_points <= 0
  end
  
  def stats
    base_stats
  end
end
