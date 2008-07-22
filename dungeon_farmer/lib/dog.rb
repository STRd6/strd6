class Dog
  include Creature
  
  def initialize
    @cell = nil
    @seeds = 0
    @image = il 'dog.png'
    @age = 0
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      if path
        self.target = path.slice! 0
      end
      
      if target
        move(target)
      else
        move([@cell.north, @cell.south, @cell.east, @cell.west].random) 
      end
    end
  end
end
