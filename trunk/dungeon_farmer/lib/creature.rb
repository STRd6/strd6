module Creature
  include Graphical
  attr_reader :cell
  attr_accessor  :target, :path, :area
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
  end
  
  def north
    move @cell.north unless @cell.north.blocked?
  end
  
  def south
    move @cell.south unless @cell.south.blocked?
  end
  
  def east
    move @cell.east unless @cell.east.blocked?
  end
  
  def west
    move @cell.west unless @cell.west.blocked?
  end
  
  def obstructs?
    true
  end
  
  def update
    
  end
  
  def can_pick_up?
    false
  end
end
