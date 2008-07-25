class Player < Creature
  attr_reader :name, :location
  
  def initialize(name)
    super 'farmer.png'
    @name = name
    @items = []
    @cell = nil
    @age = 0
    @seeds = 3
    @path = []
  end
  
  def pick_up(item)
    @items << item
  end
  
  def able_to_pick_up?(item)
    return true
  end
  
  def has_item?(item)
    @items.include? item
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    
    seeds = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= seeds
    
    @seeds += seeds.size
    
    @cell << self
  end
  
  def plant
    if @seeds > 0
      plant = Plant.new(@cell)
      plant.area = @area
      @area.add_entity(plant, @cell)
      @seeds -= 1
      notify(:plant, @cell)
    end
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
          plant
          self.target = nil
        end
      end
    end
  end
  
  def obstructs?
    true
  end
end
