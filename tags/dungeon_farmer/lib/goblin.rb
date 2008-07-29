class Goblin < Creature
  
  def initialize
    super 'goblin.png'
    @cell = nil
    @seeds = 0
    @age = 0
  end
  
  def to_s
    'Goblin'
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
    notify(:accost, self, cell) if rand(2) == 0
  end
  
  def find_path
    return if path && !path.empty?
    
    max = @area.cells.size
    n = @age*2
    
    ((n-4)..n).each do |i|
      cell = @area.cells[i%max]
      if cell.contents.size > 0
        print "#{self} finding path to cell #{cell}, contents: #{cell.contents} ... "
        self.path = @area.path @cell, cell
        puts "done!"
        return
      end
    end
  end
  
  def remove
    @cell.delete self
    @area.remove_entity self
  end
end
