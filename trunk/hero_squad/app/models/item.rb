class Item < ActiveRecord::Base
  include StatModifier
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def uses
    base_uses
  end
  
  def usable?
    return base_uses && base_uses > 0
  end
end
