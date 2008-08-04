class Chipmunk < Creature
  def initialize
    super 'chipmunk.png'
    
    @age += rand 32
  end
  
  def find_path
    if @age % 32 == 0
      if rand(@seeds) >= 1
        cell = @area.random_open
        add_task Task.new(cell, [cell], :plant)
        @activity = :plant
      else
        @activity = :get
      end
    else
      @activity = :none
    end
    
    super
  end
  
end

class Dog < Creature
  
  def initialize(owner)
    super 'dog.png'
    @owner = owner
    @managers[:follow] = Manager.new
  end
  
  def find_path
    if @activity == :none && @age % 32 == 0
      add_task Task.new(@owner.cell, [@owner.cell], :follow)
      @activity = :follow
    end
    
    super
  end
  
  def follow
    @activity = :none
  end
end

class Raccoon < Creature
  
  def initialize
    super 'raccoon.png'
  end
  
  def get
    puts "#{self} picked stuff up!"
    seeds = @cell.seeds
    @cell.seeds -= seeds
    @seeds += seeds
    
    items = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= items
  end
  
  def move(to_cell)
    super to_cell
    
    @cell.neighbours.each do |cell|
      if cell.has_resource?
        add_task(Task.new(cell, [cell], :get))
        @activity = :get
      end
    end
  end
end
