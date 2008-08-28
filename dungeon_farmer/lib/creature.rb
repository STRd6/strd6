class Creature < GameEntity
  
  attr_accessor  :path, :task, :next_task, :activity, :items
  
  def self.actions
    [:dig, :get, :plant]
  end
  
  def initialize(img)
    super(img)
    @seeds = 0
    @path = []
    
    @items = []
    
    @managers = self.class.actions.inject({}) do |hash,action|
      hash[action] = MetricManager.new(self)
      hash
    end
    @current_task = nil
    @activity = :none
  end
  
  # Return a helpful information string for debugging
  def debug
    s = "#{to_s}\n"
    @managers.each_value do |m|
      s << "  #{m.debug}\n"
    end
    
    return s
  end
  
  # Return a set of all tasks
  def all_tasks
    tasks = Set.new
    
    @managers.each_value do |m|
      tasks.merge m.all_tasks
    end
    
    return tasks
  end
  
  # Returns true if the task was added to this creature, false otherwise
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
      if t.over
        manager.cancel t
        t = nil
      elsif t.unblocked_cells.empty?
        manager.deactivate_task(t)
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
    seed = @items.detect {|item| item.plant }
    
    if seed
      @items.delete(seed)
      notify(:plant, @cell, seed)
      
      unless @items.detect {|item| item.plant }
        @activity = :none
      end
    else
      
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
    # TODO seperate out creatures from items, choose proper method names
    seeds = @cell.contents.select {|item| item.plantable? }
    @cell.contents -= seeds
    @items.push(*seeds)
  end
  
  def random_move
    cell = [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random
    move(cell) unless cell.blocked?
  end
end
