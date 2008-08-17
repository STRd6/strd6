class Plant < GameEntity
  
  def initialize(cell)
    super()
    move cell
    @age = 0
    @listeners = {}
    @@images ||= ['seed.png', 'sprout.png', 'plant1.png', 'plant2.png', 'plant3.png'].map do
      |file| il(file)
    end
    
    @maturity_age = 200
    @death_age = 350
    @dead = false
  end
    
  def update
    @age += 1
    
    unless @dead
      if @age % 2 == 0 && mature?
        if rand(73) == 0
          fruit_cell = [@cell, @cell, @cell, @cell.north, @cell.south, @cell.east, @cell.west].random
          fruit_cell << Fruit.new
          notify(:fruit, fruit_cell)
        end
      end

      if @age >= @death_age
        die
      end
    end
  end
  
  def remove
    @cell.delete self if @cell
    @area.remove_entity self if @area
    @cell = nil
    @area = nil
  end
  
  def mature?
    @age >= @maturity_age
  end
  
  def obstructs?
    false
  end
  
  def dead?
    @dead
  end
  
  def image
    @@images[@age/50] || @@images.last
  end
  
  def can_pick_up?
    false
  end
  
  def die
    unless @dead
      rand(4).times do
        seed_cell = @cell.neighbours.random
        seed_cell.seeds += 1
        notify(:seed, seed_cell)
      end
      remove
    end
    
    @dead = true
  end
end
