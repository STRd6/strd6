require File.dirname(__FILE__) + '/test_helper.rb'

class CombatTest < Test::Unit::TestCase
  def test_new
    combat = Combat.new([Creature.new], [Creature.new])
    combat.turn
    combat.display
  end
  
end