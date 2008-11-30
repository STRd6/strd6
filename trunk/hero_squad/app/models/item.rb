class Item < ActiveRecord::Base
  include StatModifier
  
  def uses
    base_uses
  end
  
  def usable?
    return base_uses && base_uses > 0
  end
end
