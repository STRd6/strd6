class Player
  include Graphical
  attr_reader :name, :location
  attr_accessor  :target
  
  def initialize(name)
    @name = name
    @items = []
    @image = il 'farmer.png'
    @cell = nil
    @age = 0
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
    @age += 1
    
    if @age % 6 == 0
      if target
        if target.x < @cell.x
          west
        elsif target.x > @cell.x
          east
        else
          in_x = true
        end
        
        if target.y < @cell.y
          north
        elsif target.y > @cell.y
          south
        else
          in_y = true
        end
        
        if in_x and in_y
          plant
          self.target = nil
        end
        
      end
    end
  end
end
