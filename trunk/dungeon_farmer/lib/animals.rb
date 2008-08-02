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
  
  def initialize
    super 'dog.png'
  end
end

class Raccoon < Creature
  
  def initialize
    super 'raccoon.png'
  end
  
  def get
    puts "#{self} picked stuff up!"
    items = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= items
  end
end
