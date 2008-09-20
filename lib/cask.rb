lib = File.dirname(__FILE__)

class Array
  def random
    return self[rand(length)]
  end
end

require lib + '/adventurer.rb'
require lib + '/description.rb'
require lib + '/room.rb'

def story
  def press_enter
    puts '(Press enter)'
    gets
  end

  puts <<EOF
  It is about dusk, one evening during the supreme madness of the carnival 
season, that you encounter your friend Montresor. You approach him warmly, 
for you have been drinking much.

  He says to you, "My dear Fortunato, you are luckily met. How remarkably 
well you are looking to-day! But I have received a pipe of what passes for 
Amontillado, and I have my doubts."

  "How?" you say, "Amontillado? A pipe? Impossible! And in the middle of the 
carnival?"

EOF

  press_enter

  puts <<EOF
  "I have my doubts," he replies; "and I was silly enough to pay the full 
Amontillado price without consulting you in the matter. You were not to be 
found, and I was fearful of losing a bargain. I am on my way to Luchesi. If 
any one has a critical turn, it is he. He will tell me"

  "Luchesi cannot tell Amontillado from Sherry. Let us go: you have been 
imposed upon." You possess yourself of his arm and together hurry to his 
palazzo.

EOF

  press_enter

puts <<EOF
  Inside, Montresor takes from their sconces two flambeaux, and hands one to 
you, directing you through several suites of rooms to the archway that leads 
into the vaults. You pass down a long and winding staircase, coming at length 
to the foot of the descent, and you stand together on the damp ground of the 
catacombs of the Montresors.

EOF

  press_enter

  puts <<EOF
  You eagerly continue the route in search of the Amontillado. You pass 
through a range of low arches, descend, pass on, and descend again, arriving 
at a deep crypt.

You turn toward Montresor but find he is no longer there...

EOF
end

def play
  story

  adventurer = Adventurer.new(Room.new)

  while input = gets.chomp!.downcase
    if input == 'exit'
      break
    end

    adventurer.process(input)
  end
end

if __FILE__ == $0
  play
end
