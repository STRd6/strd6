class Item < GameEntity
  attr_reader :value
  
  def initialize(img)
    super(img)
  end
  
  def can_pick_up?
    true
  end
end
