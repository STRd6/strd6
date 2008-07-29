class Area
  attr_reader :cells, :player, :goblin, :chips
  
  def initialize(width, height)
    @graph = UndirectedGraph.new
    @cells = []
    @entities = []
    
    heights = DiamondSquare.go(5)
    
    @width = width
    @height = height
    
    height.times do |row|
      @cells << []
      width.times do |col|
        @cells[row] << Cell.new(col, row, heights[row][col])
      end
    end
    
    cells = self.cells
    cells.each_index do |i|
      cell = cells[i]
      
      #Set up neighbours
      row = i / width
      col = i % width
      
      cell.north = cells[((row - 1)%height)*width + col]
      cell.south = cells[((row + 1)%height)*width + col]
      cell.east = cells[row*width + (col + 1)%width]
      cell.west = cells[row*width + (col - 1)%width]
      
      unless cell.blocked?
        #Set up graph
        @graph.add_edge!(cell, cell.north, 1) unless cell.north.blocked?
        @graph.add_edge!(cell, cell.south, 1) unless cell.south.blocked?
        @graph.add_edge!(cell, cell.east, 1) unless cell.east.blocked?
        @graph.add_edge!(cell, cell.west, 1) unless cell.west.blocked?
      end
      
      #Place Seeds
      cell.seeds += 1 if !cell.blocked? && rand(90) == 0
    end
    
    @player = Player.new("Alfonso Fonzarelli")
    @player.move(random_open)
    @player.area = self
    
    dog = Creature.new('dog.png')
    dog.move(random_open)
    
    raccoon = Creature.new('raccoon.png')
    raccoon.move(random_open)
    
    @chips = []
    
    (rand(3) + 1).times do
      chip = Creature.new('chipmunk.png') do
        @age += 1

        if @seeds > 0
          @task = :plant
        end

        if @age % 17 == 0
          @task = :get
        end

        if @age % 2 == 0
          if @path.empty?
            case @task
            when :get
              notify(:no_path_s, self)
            when :plant
              @plant_cell = @area.random_open
              @path = @area.path(@cell, @plant_cell)
            end

            if @path.empty?
              @task = :none
            end
          else
            @target = path.slice! 0
          end

          if @target
            move(@target)
            if path == []

              case @task
              when :get
                pick_up
                @seeds = [@seeds-1, 0].max if rand(3) == 0
              when :plant
                plant
              end

              @task = :none
            end
          else
            c = [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random
            move(c) unless c.blocked?
          end
        end
      end
      chip.area = self
      chip.seeds = rand(3)
      chip.move(random_open)
      @entities << chip
      @chips << chip
    end
    
    @entities << @player
    @entities << dog
    @entities << raccoon
  end
  
  def uncover_goblin(cell)
    goblin = Goblin.new
    goblin.move(cell)
    goblin.area = self
    @entities << goblin
    
    return goblin
  end
  
  def connect(cell)
    unless cell.blocked?
      cell.neighbours.each do |n|
        @graph.add_edge!(cell, n, 1) unless n.blocked?
      end
    end
  end
  
  def random_open
    cell = cells.random
    cell = cells.random until !cell.blocked?
    return cell
  end
  
  def cells
    @cells.flatten
  end
  
  def add_entity(entity, cell)
    cell << entity
    @entities << entity
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
    return path.slice(1, path.size)
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
end
