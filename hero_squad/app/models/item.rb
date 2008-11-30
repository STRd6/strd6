class Item < ActiveRecord::Base
  before_create :ensure_stat_mods
  
  def uses
    base_uses
  end
  
  def usable?
    return base_uses && base_uses > 0
  end
  
  protected
  def ensure_stat_mods
    self.stat_mods ||= {}
  end
end
