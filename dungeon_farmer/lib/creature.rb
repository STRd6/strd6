class Creature
  include Graphical, Observable
  attr_reader :cell
  attr_accessor  :target, :path, :area, :task, :next_task, :seeds
  
  def initialize(img, &block)
    @image = il img if img
    @seeds = 0
    @cell = nil
    @age = 0
    @listeners = {}
    @path = []
    
    
    if block_given?
      @update_block = block
    end
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
    if @update_block
      return instance_eval(&@update_block)
    end
    
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
        random_move
      end
    end
  end
  
  def plant
    if @seeds > 0
      plant = Plant.new(@cell)
      plant.area = @area
      @area.add_entity(plant, @cell)
      notify(:plant, @cell, plant)
      
      @seeds -= 1
      if @seeds == 0
        @task = :none
      end
    end
  end
  
  def pick_up
    seeds = @cell.seeds
    @cell.seeds -= seeds
    @seeds += seeds
    notify(:pick_up, self, @cell)
  end
  
  def random_move
    cell = [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random
    move(cell) unless cell.blocked?
  end
  
  def remove
    
  end
  
  def can_pick_up?
    false
  end
end
