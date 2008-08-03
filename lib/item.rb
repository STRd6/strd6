module Item
  include Graphical
  
  attr_reader :value
  
  def update
    
  end
  
  def obstructs?
    false
  end
  
  def can_pick_up?
    true
  end
  
  def remove
    
  end
end
