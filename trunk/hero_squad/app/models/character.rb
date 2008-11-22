class Character < ActiveRecord::Base
  has_one :primary_item, :class_name => 'Item'
  has_one :secondary_item, :class_name => 'Item'
  
  #alias_method :hp, :hit_points 
  #alias_method :en, :energy
  
  def dead?
    hit_points <= 0
  end
  
  def abilities
    []
  end
  
  def stats
    base_stats
  end
end
