class Player < Creature
  attr_reader :name, :location
  
  def initialize(name)
    super 'farmer.png'
    @name = name
    @cell = nil
    @age = 0
    @seeds = 3
  end
  
  def to_s
    name
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
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
  
  def dig(cell)
    puts "#{self} is digging at #{cell}"
    notify(:dig, @cell, cell)
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      if path.empty?
        notify(:no_path, self)
      else
        self.target = path.slice! 0
      end
      
      if target
        move(target)
        if path == []
          self.target = nil
          
          case task
          when :plant
            plant
          when :get
            pick_up
          when :dig
            @cell.neighbours.each do |c|
              if c.to_dig
                dig c
                break
              end
            end
            notify(:clear_target, :dig, @cell)
          end
          
          @task = @next_task if @next_task
          @next_task = nil
          
        end
      end
    end
  end
  
  def obstructs?
    true
  end
end
