class Hex
  
end

class HexBoard
  def initialize(rows, cols)
    @rows, @cols = rows, cols
    @board = Array.new(@rows) do |row|
      Array.new(@cols) do |col|
        Hex.new
      end
    end
  end
  
  def distance(pos1, pos2)
    dx = pos2[0] - pos1[0]
    dy = pos2[1] - pos1[1]
    return (dx.abs + dy.abs + (dx - dy).abs) / 2
  end
  
  def draw
    @rows.times do |row|
      (@rows - row).times {putc ' '}
      
      @cols.times do |col|
        putc distance([4,3], [row,col]).to_s
        putc ' '
      end
      
      puts #Spacer
    end
  end
  
  def [](row)
    @board[row]
  end
end