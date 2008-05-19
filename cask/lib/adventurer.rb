class Adventurer
  def initialize(room)
    @current_room = room
    @visited_rooms = {}

    @hunger = -1
    @tiredness = -1

    @help_count = 0

    update_status
  end

  def current_room
    @current_room
  end

  def process(input)
    case input
    when 'north', 'n'
      move :north
    when 'south', 's'
      move :south
    when 'east', 'e'
      move :east
    when 'west', 'w'
      move :west
    when 'look', 'l'
      update_status
    when 'search'
      search
    when 'help', 'h'
      help
    else
      puts "I do not understand '#{input}'."
      @help_count += 1
      if @help_count % 3 == 0
        help
      end
    end
  end

  def search
    puts @current_room.search(adverb)
    update_status
  end

  def move(direction)
    result = @current_room.move(direction)

    if result
      # (Re-)entering room text here.
      puts "You move to the #{direction}."
      @current_room = result
    else
      puts "You stay where you are."
    end

    update_status
  end

  def update_status
    @hunger += 1
    @tiredness += 1

    case @hunger 
    when 9
      puts "You are getting hungry."
    when 15
      puts "You are starving."
    when 18
      puts "You have starved to death."
      exit
    end

    if @tiredness > 5 + rand(6)
      sleep
    end

    puts @current_room.description

    print "> "
  end

  def adverb
    if @hunger < 6
      " carefully"
    elsif @hunger < 10
      " anxiously"
    elsif @hunger < 15
      " desperately"
    else
      " hopelessly"
    end
  end

  def help
   puts <<EOF
Type a direction or the first letter of that direction to move.
Type 'look' or 'l' to view your current surroundings.
Type 'search' to examine the room you are in.
Type 'help' or 'h' to view this help message.
EOF
  end

  def sleep
    puts "You are so tired that you lie down to rest."
    puts "     zzz...         zzz...         zzz...     "
    # Flashback dream

    if rand(3) != 0 && !@current_room.trap
      @current_room = Room.new(:north, nil, true)
      sleep_story
    end

    puts "You awaken in the dark."
    @tiredness = 0
  end

  def sleep_story
puts <<EOF
You remember Montressor handing you a flagon of De Grave. You emptied it at a 
breath and laughed throwing the bottle upwards, a symbol of The Brotherhood; 
he did not understand.

He looked at you in surprise. You repeated the movement.

"You do not comprehend?"

"Not I," he replied.
EOF

    puts '(Press enter)'
    gets

puts <<EOF
"Then you are not of The Brotherhood."

"How?"

"You are not of the masons."

"Yes, yes," he said "yes! yes."
EOF

    puts '(Press enter)'
    gets

puts <<EOF
"You? Impossible! A mason?"

"A mason," he replied.

"A sign," you said.

"It is this," he answered, producing a trowel from beneath the folds of his 
roquelaire.

"You jest," you exclaimed, recoiling a few paces. "But let us proceed to the 
Amontillado."
EOF
  end
end
