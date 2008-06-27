lib = File.dirname(__FILE__) + '/'

require File.dirname(__FILE__) + '/../../gutil/lib/random.rb'
require File.dirname(__FILE__) + '/../../gutil/lib/dice.rb'
require 'yaml'

require lib + 'attack.rb'
require lib + 'combat.rb'

require lib + 'events.rb'
require lib + 'creature.rb'

require lib + 'game.rb'
require lib + 'item.rb'
require lib + 'recipe.rb'
require lib + 'stockpile.rb'
require lib + 'village.rb'


if __FILE__ == $0
  village1 = Village.new
  4.times do
    village1.add_resident Creature.new("Elf", 90)
    village1.add_item Item.random
  end
  
  village2 = Village.new
  3.times do
    village2.add_resident Creature.new("Goblin", 120)
    village2.add_item Item.random
    village2.add_item Shield.random
  end
  
  puts village1.items
  puts village2.items
  
  village1.arm!
  
  village2.arm!
  village2.arm!
  village2.arm!
  
  combat = Combat.new(village1.residents, village2.residents)

  combat.display

  t = 0
  while combat.turn do
    t += 1
    puts "End turn #{t}"
  end

  combat.display
end
