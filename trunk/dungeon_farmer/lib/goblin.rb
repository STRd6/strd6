class Goblin
  include Creature
  
  def initialize
    @cell = nil
    @seeds = 0
    @image = il 'goblin.png'
    @age = 0
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    
    seeds = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= seeds
    
    @seeds += seeds.size
    
    @cell << self
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      if path
        self.target = path.slice! 0
      end
      
      if target
        move(target)
      else
        move([@cell.north, @cell.south, @cell.east, @cell.west].random) 
      end
    end
  end
  
end
