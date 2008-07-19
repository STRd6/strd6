class Player
  include Graphical
  attr_reader :name, :location
  
  def initialize(name, window)
    @name = name
    @items = []
    @image = il 'farmer.png'
    @x = 216
    @y = 216
    @cell = nil
  end
  
  def pick_up(item)
    @items << item
  end
  
  def able_to_pick_up?(item)
    return true
  end
  
  def has_item?(item)
    @items.include? item
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
  end
  
  def north
    move @cell.north
  end
  
  def south
    move @cell.south
  end
  
  def east
    move @cell.east
  end
  
  def west
    move @cell.west
  end
  
  def plant
    @cell << Plant.new
  end
  
  def update
    
  end
end
