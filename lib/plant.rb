class Plant < GameEntity
  
  def initialize(cell)
    super()
    move cell
    @age = 0
    @listeners = {}
    @@images ||= ['seed.png', 'sprout.png', 'plant1.png', 'plant2.png', 'plant3.png'].map do
      |file| il(file)
    end
  end
    
  def update
    @age += 1
    
    if @age % 2 == 0 && mature?
      if rand(73) == 0
        fruit_cell = [@cell, @cell, @cell, @cell.north, @cell.south, @cell.east, @cell.west].random
        fruit_cell << Fruit.new
        notify(:fruit, fruit_cell)
      end
    end
    
    if dead?
      rand(4).times do
        seed_cell = @cell.neighbours.random
        seed_cell.seeds += 1
        notify(:seed, seed_cell)
      end
      remove
    end
  end
  
  def remove
    @cell.delete self
    @area.remove_entity self
  end
  
  def mature?
    @age > 199
  end
  
  def obstructs?
    false
  end
  
  def dead?
    @age > 349
  end
  
  def image
    @@images[@age/50] || @@images.last
  end
  
  def can_pick_up?
    false
  end
end
