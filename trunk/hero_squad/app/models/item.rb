class Item < ActiveRecord::Base
  include StatModifier
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def uses
    base_uses
  end
  
  def usable?
    base_uses && base_uses > 0
  end
  
  def invoke_action
    if usable?
      true
    else
      nil
    end
  end
  
  def css_class
    secondary? ? "secondary" : "primary"
  end
end
