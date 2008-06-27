require File.dirname(__FILE__) + '/test_helper.rb'

class AttackTest < Test::Unit::TestCase
  def test_new
    assert Attack.new(Creature.new)
  end
  
  def test_dmg
    attack = Attack.new(Creature.new)
    
    hit = attack.hit?(:str => 100, :dex => 100)
    
    assert (hit == true || hit == false)
    assert attack.dmg[:blunt] >= 0
  end
  
end
