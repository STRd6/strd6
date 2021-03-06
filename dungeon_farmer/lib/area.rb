class Area
  attr_reader :cells, :player
  
  def initialize(width, height)
    @graph = UndirectedGraph.new
    @cells = []
    @entities = []
    
    heights = DiamondSquare.go(5)
    
    @width = width
    @height = height

    #Initialize Cells
    @height.times do |row|
      @cells << []
      @width.times do |col|
        @cells[row] << Cell.new(col, row, heights[row][col])
      end
    end
    
    @height.times do |row|
      @cells << []
      @width.times do |col|
        #Set up neighbours
        cell = @cells[row][col]
        cell.north = @cells[(row-1)%@height][col]
        cell.south = @cells[(row+1)%@height][col]
        cell.east = @cells[row][(col+1)%@width]
        cell.west = @cells[row][(col-1)%@width]
        
        #Set up graph
        connect cell
        
        if !cell.blocked?
          case rand(100)
          when 0..2
            cell << Seed.new(Bush)
          when 6..10
            tree = Tree.new(cell)
            tree.instance_eval do
              @age = rand 500
            end
            add_entity(tree)
          end
          
        end
      end
    end
    
    @player = Player.new("Alfonso Fonzarelli")
    @player.move(random_open)
    @player.add_listener(:plant, self)
    @player.add_listener(:dig, self)
    
    @dog = Dog.new(@player)
    @dog.move(random_open)
    
    @raccoon = Raccoon.new
    @raccoon.move(random_open)
    
    @chips = []
    
    3.times do
      chip = Chipmunk.new
      # TODO Seeds
      rand(4).times { chip.items << Seed.new(Bush) }
      chip.move(random_open)
      
      chip.add_listener(:plant, self)
      chip.activity = :get
      
      add_entity chip
      @chips << chip
    end
   
    cells.each do |cell|
      if cell.has_resource?
        task = Task.new(cell, [cell], :get)
        task.cancel unless @chips.random.add_task(task)
      end
    end
    
    add_entity @player
    add_entity @dog
    add_entity @raccoon
  end
  
  def all_tasks
    tasks = @player.all_tasks + @raccoon.all_tasks + @dog.all_tasks
    
    @chips.each do |chip|
        tasks += chip.all_tasks
    end
    
    return tasks
  end
  
  def uncover_goblin(cell)
    goblin = Goblin.new
    goblin.move(cell)
    goblin.add_listener(:accost, self)
    add_entity goblin
  end
  
  # Connect this cell to the graph
  def connect(cell)
    unless cell.blocked?
      cell.neighbours.each do |n|
        @graph.add_edge!(cell, n, 1) unless n.blocked?
      end
    end
  end
  
  # Disconnect this cell from the graph
  def disconnect(cell)
    if cell.blocked?
      cell.neighbours.each do |n|
        @graph.remove_edge!(cell, n) unless n.blocked?
      end
    end
  end
  
  # Returns an unblocked cell at random, hangs if no unblocked cells
  def random_open
    cell = cells.random
    cell = cells.random until !cell.blocked?
    return cell
  end
  
  def cells
    @cells.flatten
  end
  
  def add_entity(entity)
    @entities << entity
    entity.area = self
  end
  
  def remove_entity(entity)
    @entities.delete entity
  end
  
  def path(cell1, cell2)
    h = Proc.new do |v| 
      if v == cell2
        0
      else
        if v.blocked?
          60000
        else
          x = (v.x - cell2.x).abs
          y = (v.y - cell2.y).abs
          [x, @width - x].min + [y, @height - y].min
        end
      end
    end
    
    examined = 0
    
    ev = Proc.new do |v|
      examined += 1
      if examined > 100
        puts "Too many!"
        @task = :none
        return []
      end
    end
    
    begin #TODO: Find out why GRATR throws exception, possibly trapped path or disconnected.
      path = @graph.astar(cell1, cell2, h, {:examine_vertex => ev})
    rescue
      path = []
    end
    
    puts "#{examined} examined ... "
    return [] if path.nil?
    return path.slice(1, path.size) || []
  end
  
  def cells_in(x1, x2, y1, y2)
    cells = []
    
    (y1..y2).each do |row|
      cells << @cells[row][x1..x2]
    end
    
    return cells.flatten!
  end
  
  def update
    #@cells.each {|c| c.update }
    @entities.each {|c| c.update }
  end
  
  
  #### Callbacks ####
  def seed(cell)
    task = Task.new(cell, [cell], :get)
    added = false
    
    @chips.each do |chip|
      added ||= chip.add_task(task)
    end
    
    task.cancel unless added
  end
  
  def fruit(cell)
    if rand(3) == 0
      @raccoon.add_task(Task.new(cell, [cell], :get))
      @raccoon.activity = :get
    end
  end
  
  def plant(cell, seed)
    plant = seed.plant.new(cell)
    plant.add_listener(:seed, self)
    plant.add_listener(:fruit, self)
    add_entity(plant)
  end
  
  def dig(standing, task_cell)
    task_cell.dig
    connect task_cell
    
    if rand(32) == 0
      uncover_goblin(task_cell) 
    end
    
    if rand(8) == 0
      task_cell << Prize.generate
      if rand(3) == 0
        @raccoon.add_task(Task.new(task_cell, [task_cell], :get)) 
        @raccoon.activity = :get
      end
    end
  end
  
  def flood(cell)
    cell.flood
    disconnect cell
  end
  
  def accost(creature, cell)
    cell.contents.each do |content|
      content.remove unless content == creature
    end
  end
end
