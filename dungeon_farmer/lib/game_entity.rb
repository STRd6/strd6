class GameEntity
  include Graphical, Observable
  
  attr_reader :cell
  attr_accessor :area
  
  def initialize
    @cell = nil
    @area = nil
    @age = 0
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
  end
  
  def update
    @age += 1
  end
  
  def obstructs?
    false
  end
  
  def remove
    
  end
  
  def can_pick_up?
    false
  end
end
