# Get some dice action going on
class Fixnum
  def d(sides)
    sum = 0
    self.times {sum += Kernel.rand(sides) + 1}
    return sum
  end
end

# Cells keep track of their own hit count and any crazy bonus moves
class Cell
  @@cell_pos = 0
  attr_accessor :count
  
  def initialize(name, block)
    @count = 0
    @name = name.gsub('_', ' ')
    @position = @@cell_pos
    @@cell_pos += 1
    @move_block = block
  end
  
  # Record that the token landed on this cell
  # Return any bonus move (new location)
  def land
    @count += 1
    # Sometimes cells have a bonus move, this returns
    # the new location, could be the same if no bonus move.
    @move_block.call(@position)
  end
  
  # Print out this cells name and count
  def to_s
    "(#{"%02d" % @position}) #{@name}#{spacing}- #{@count}"
  end
  
  def spacing
    s = " "
    (21 - @name.size).times do
      s += " "
    end
    s
  end
end

class Board
  PROPERTY_NAMES = %w[GO Mediterranian Community_Chest Baltic Income_Tax Reading_Railroad Oriental Chance Vermont Connecticut
    Jail/Just_Visiting St._Charles_Place Electric_Company States Virginia Pennsylvania_Railroad St._James_Place Community_Chest Tennessee New_York
    Free_Parking Kentucky Chance Indiana Illinois B&O_Railroad Atlantic Ventnor Water_Works Marvin_Gardins
    Go_To_Jail Pacific North_Carolina Community_Chest Pennsylvania Short_Line_Railroad Chance Park_Place Luxury_Tax Boardwalk]
      
  # Some Board positions
  GO_POSITION = 0
  READING_POSITION = 5
  JAIL_POSITION = 10
  ST_CHARLES_POSITION = 11
  ELECTRIC_COMPANY_POSITION = 12
  ILLINOIS_POSITION = 24
  WATER_WORKS_POSITION = 28
  BOARDWALK_POSITION = 39

  CHANCE_CARDS = 15
  COMMUNITY_CHEST_CARDS = 16
  BOARD_SIZE = 40
  
  COMMUNITY_CHEST_EFFECT = lambda do |cur_pos|
    # Simulate 16 card Community chest deck
    case Kernel.rand(COMMUNITY_CHEST_CARDS)
    when 0
      GO_POSITION
    when 1
      JAIL_POSITION
    else
      # This card does not have an effect on position
      cur_pos
    end
  end
  
  CHANCE_EFFECT = lambda do |cur_pos|
    case Kernel.rand(CHANCE_CARDS)
    when 0
      GO_POSITION
    when 1
      ILLINOIS_POSITION
    when 2
      # Nearest Utility
      if (cur_pos >= WATER_WORKS_POSITION) || (cur_pos < ELECTRIC_COMPANY_POSITION)
        ELECTRIC_COMPANY_POSITION
      else
        WATER_WORKS_POSITION
      end
    when 3..4
      # Nearest Railroad
      case cur_pos
      when 5..14
        15
      when 15..24
        25
      when 25..34
        35
      else
        READING_POSITION
      end
    when 5
      ST_CHARLES_POSITION
    when 6
      # Go back three spaces
      cur_pos - 3
    when 7
      JAIL_POSITION
    when 8
      READING_POSITION
    when 9
      BOARDWALK_POSITION
    else
      # This card does not have an effect on position
      cur_pos
    end
  end

  # Roll 2d6
  def roll
    2.d 6
  end

  def initialize
    # Stay put Proc, used in most regular cells
    stay_put = Proc.new {|cur_pos| cur_pos}

    # Procs for Chance, Community Chest and Go To Jail
    proc_for_name = {
      "Community_Chest" => COMMUNITY_CHEST_EFFECT,
      "Chance" => CHANCE_EFFECT,
      "Go_To_Jail" => lambda {|cur_pos|
        JAIL_POSITION
      }
    }
      
    @cells = PROPERTY_NAMES.map do |name|
      # Create the cell and give it it's bonus move behavior proc
      Cell.new(name, proc_for_name[name] || stay_put)
    end
    
    def simulate(moves)
      position = 0

      moves.times do
        position += roll
      
        # Land on the cells and keep following the cards until we stay put
        while( position != (new_position = (cells[position % BOARD_SIZE]).land) ) do
          position = new_position
          # Track the extra moves
          moves += 1
        end
      end
    end
  
    # Displays the results of the simulation
    # Permanently alters the cells making them unsuitable for
    # further simulation.
    def display
      puts "Total hits in board order after #{moves} turns:"
      puts cells
      puts "------"

      puts "Sorted by Relative Frequency: "
      # Sort and display results
      cells.sort{|a, b| b.count <=> a.count }.each do |cell|
        cell.count = "%1.4f%" % (cell.count * 100 / moves.to_f)
        puts cell
      end
      puts "------"
    end
  end

  board = Board.new

  board.simulate((ARGV[0] || 100000).to_i)
  board.display


