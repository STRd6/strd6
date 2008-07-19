class Area
  attr_reader :cells, :player
  
  def initialize(width, height)
    @cells = []
    height.times do |row|
      width.times do |col|
        @cells << Cell.new(col, row)
      end
    end
    
    @cells.each_index do |i|
      row = i / width
      col = i % width
      
      @cells[i].north = @cells[((row - 1)%height)*width + col]
      @cells[i].south = @cells[((row + 1)%height)*width + col]
      @cells[i].east = @cells[row*width + (col + 1)%width]
      @cells[i].west = @cells[row*width + (col - 1)%width]
    end
    
    @player = Player.new("X")
    @player.move(@cells[500])
  end
  
  def update
    @cells.each {|c| c.update }
  end
end
