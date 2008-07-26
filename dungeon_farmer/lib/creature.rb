class Creature
  include Graphical, Observable
  attr_reader :cell, :seeds
  attr_accessor  :target, :path, :area, :task, :next_task
  
  def initialize(img)
    @image = il img if img
    @seeds = 0
    @cell = nil
    @age = 0
    @listeners = {}
  end
  
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
    false
  end
  
  def find_path
    
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      find_path
      
      if path
        self.target = path.slice! 0
      end
      
      if target
        if target.blocked?
          self.path = nil
          self.target = nil
        else
          move(target)
        end
      else
        cell = [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random
        move(cell) unless cell.blocked?
      end
    end
  end
  
  def pick_up
    seeds = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= seeds
    @seeds += seeds.size
    notify(:pick_up, self, @cell)
  end
  
  def can_pick_up?
    false
  end
end
