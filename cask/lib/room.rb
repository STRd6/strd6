class Room
  @@id = 0

  attr_reader :trap

  def initialize(door_to = :north, room = nil, trap = false)
    @id = @@id += 1
    @times_described = 0
    @doors = {}
    @bricks = [rand(20) - 14, 0].max

    @descrip = Description.new

    if trap
      # There is no way out.
      @trap = true
    else
      directions.each do |door|
        # Add a door to a room to be lazily created
        @doors[door] = nil if rand(2) == 0
      end

      @doors[door_to] = room
    end
  end

  def move(direction)
    # puts "Move: #{direction}"
    if @doors.has_key? direction
      # puts "@doors[direction] = #{@doors[direction]}"
      # Now create the room
      @doors[direction] = Room.new(opposite(direction), self) unless @doors[direction]
      return @doors[direction]
    end
  end

  def search(adverb)
    desc = "You#{adverb} search... "
    if rand(2) == 0
      @bricks += 1
      desc += "and have discovered a loose brick!"
    else
      desc += "but in vain."
    end
  end

  def description
    debug = "Room: #{@id}\n"

    desc = ''

    # desc += "You return.\n" if @times_described > 0

    desc += @descrip.describe.capitalize

    case @bricks
    when 0
      quantity = "no"
    when 1
      quantity = "a"
    when 2
      quantity = "a couple of"
    when 3..4
      quantity = "a few"
    when 5..7
      quantity = "some"
    else
      quantity = "many"
    end

    desc += "You notice #{quantity} loose brick#{'s' if @bricks != 1}.\n" if @bricks > 0

    if @doors.length > 1
      desc += "The are doors to the: \n"
    elsif @doors.length == 1
      desc += "The is a door to the "
    else
      desc += "This room has no door!\n"
    end

    @doors.each_key do |key|
      desc += "#{key}\n"
    end

    @times_described += 1

    return desc
  end

  def opposite(door)
    case door
    when :north
      :south
    when :south
      :north
    when :east
      :west
    when :west
      :east
    else
      nil
    end
  end

  def directions
    [:north, :south, :east, :west]
  end
end
