class Item < ActiveRecord::Base
  def uses
    base_uses
  end
  
  def stat_mods
    {}
  end
  
  def usable?
    return base_uses && base_uses > 0
  end
end
