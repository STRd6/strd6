class Seed
  include Graphical
  
  def initialize
    @image = il 'seed.png'
  end
  
  def update
    
  end
  
  def obstructs?
    false
  end
  
  def can_pick_up?
    true
  end
end
