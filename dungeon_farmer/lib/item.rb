class Item < GameEntity
  attr_reader :value
  
  def initialize(img, options={})
    options = {:edible => false, :value => 0}.merge! options
    super(img, options)
  end
  
  def edible?
    @edible
  end
  
  def can_pick_up?
    true
  end
end
