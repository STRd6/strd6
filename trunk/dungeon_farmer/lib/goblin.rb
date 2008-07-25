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
    
    seeds = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= seeds
    
    @seeds += seeds.size
    
    @cell << self
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
  
end
