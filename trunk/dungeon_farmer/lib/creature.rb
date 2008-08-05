class Creature < GameEntity
  
  attr_accessor  :path, :task, :next_task, :seeds, :activity
  
  def self.actions
    [:dig, :get, :plant]
  end
  
  def initialize(img)
    super(img)
    @seeds = 0
    @listeners = {}
    @path = []
    
    @managers = self.class.actions.inject({}) do |hash,action|
      hash[action] = Manager.new
      hash
    end
    @current_task = nil
    @activity = :none
  end
  
  def add_task(task)
    @managers[task.activity].add_task(task)
  end
  
  # Selects an action from the manager for the current activity
  # Returns the path to a cell at which the action can be performed or
  # [] if no path found.
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
      @current_task = t
      @act_cell = t.unblocked_cells.random
      
      if @cell == @act_cell
        return []
      else
        path = @area.path(@cell, @act_cell)
        
        if path.empty?
          # Deactivate if inaccessable
#          @current_task = nil
#          manager.deactivate_task
        end
        
        return path
      end      
    else
      return []
    end
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      # If Creature has a task and the task can be performed from the current cell
      if @current_task && @current_task.perform_cells.include?(@cell)
        # Perform
        send @current_task.activity
        
        @managers[@current_task.activity].accomplish @current_task
        @current_task = nil
        @act_cell = nil
        @path = []
      else # Find the next place to move
        if @path.empty?
          @path = find_path
        end
        
        target = @path.shift

        if target
          if target.blocked?
            @path = []
          else
            move(target)
          end
        else
          no_target
        end
      end
        
    end
  end
  
  def no_target
    random_move
  end
  
  def plant
    if @seeds > 0
      notify(:plant, @cell)
      
      @seeds -= 1
      if @seeds == 0
        @activity = :none
      end
    end
  end
  
  def dig
    cell = @current_task.target_cell
    
    puts "#{self} is digging at #{cell}"
    notify(:dig, @cell, cell)

    @managers[:dig].activate_tasks cell
  end
  
  def get
    puts "#{self} picked stuff up!"
    seeds = @cell.seeds
    @cell.seeds -= seeds
    @seeds += seeds
  end
  
  def random_move
    cell = [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random
    move(cell) unless cell.blocked?
  end
end
