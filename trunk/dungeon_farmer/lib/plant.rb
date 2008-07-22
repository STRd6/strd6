class Plant
  include Graphical
  attr_reader :age
  attr_accessor :area
  
  def initialize(cell)
    @cell = cell
    @age = 0
    @@images ||= ['seed.png', 'sprout.png', 'plant1.png', 'plant2.png', 'plant3.png'].map do
      |file| il(file)
    end
  end
    
  def update
    @age += 1
    
    if dead?
      rand(3).times do
        @area.add_entity(Seed.new, [@cell.north, @cell.south, @cell.east, @cell.west, @cell].random)
        @cell.delete self
        @area.remove_entity self
      end
    end
  end
  
  def mature?
    age > 99
  end
  
  def obstructs?
    return mature?
  end
  
  def dead?
    age > 349
  end
  
  def image
    @@images[@age/50] || @@images.last
  end
  
  def can_pick_up?
    false
  end
end
