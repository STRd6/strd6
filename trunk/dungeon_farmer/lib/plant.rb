class Plant < GameEntity
  
  def initialize(cell, options={})
    options = {
      :age_rate => 50, 
      :maturity_age => 200, 
      :death_age => 350,
      :images => [default_image],
    }.merge options
    
    super(nil, options)
    
    move cell
    @dead = false
  end
  
  def default_image
    il("question.png")
  end
    
  def update
    @age += 1
    
    unless @dead
      on_update

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
    @images[@age/@age_rate] || @images.last
  end
  
  def can_pick_up?
    false
  end

protected  
  def die
  end
  
  def on_update
  end
end

class Bush < Plant
  
  def initialize(cell)
    @@images ||= %w[bush_seed bush0 bush1 bush2 bush3].map do
      |file| il("plants/#{file}.png")
    end
    
    super(cell, 
      :images => @@images, 
      :age_rate => 50, 
      :maturity_age => 200, 
      :death_age => 400)
  end

protected  
  def die
    unless @dead
      rand(4).times do
        seed_cell = @cell.neighbours.random
        seed_cell.seeds += 1
        notify(:seed, seed_cell)
      end
    end

    remove
    @dead = true
  end
  
  def on_update
    if @age % 2 == 0 && mature?
      if rand(73) == 0
        fruit_cell = [@cell, @cell, @cell, @cell.north, @cell.south, @cell.east, @cell.west].random
        fruit_cell << Item.new("fruit.png", :value => 2, :edible => true)
        notify(:fruit, fruit_cell)
      end
    end
  end
end

class Tree < Plant
  
  def initialize(cell)
    @@images ||= %w[tree_seed tree0 tree1 tree2 tree3].map do
      |file| il("plants/#{file}.png")
    end
    
    super(cell, 
      :images => @@images, 
      :age_rate => 100, 
      :maturity_age => 400, 
      :death_age => 5000)
    
  end
    
protected  
  def die
    unless @dead
      remove
    end
    
    @dead = true
  end
  
  def on_update
    
  end
end
