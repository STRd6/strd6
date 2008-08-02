class Creature < GameEntity
  
  attr_accessor  :path, :task, :next_task, :seeds, :activity
  
  def self.actions
    [:dig, :get, :plant]
  end
  
  def initialize(img, &block)
    super()
    @image = il img if img
    @seeds = 0
    @listeners = {}
    @path = []
    
    @managers = self.class.actions.inject({}) do |hash,action|
      hash[action] = Manager.new
      hash
    end
    @current_task = nil
    @activity = :none
    
    if block_given?
      @update_block = block
    end
  end
  
  def obstructs?
    false
  end
  
  def find_path
    manager = @managers[@activity]
    return [] unless manager
    
    while t = manager.get_task
      #puts t
      if t.unblocked_cells.empty?
        manager.deactivate_task
        t = nil
      else
        break
      end
    end
    
    if t
      @act_cell = t.unblocked_cells.random
      path = @area.path(@cell, @act_cell)
      #puts path
      @current_task = t
      return path
    else
      return []
    end
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      @path = find_path
      
      if path
        target = path.slice! 0
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
  
  def dig
    cell = @current_task.target_cell
    
    puts "#{self} is digging at #{cell}"
    notify(:dig, @cell, cell)

    @managers[:dig].activate_tasks cell
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
