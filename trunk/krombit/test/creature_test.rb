require File.dirname(__FILE__) + '/test_helper.rb'

class CreatureTest < Test::Unit::TestCase
  def test_new
    c = Creature.new
    
    #Should have some description
    assert c.describe.length > 0
    
    #New creature should not be dead
    assert !c.dead?
  end
  
  def test_get_attack
    c = Creature.new
    assert c.get_attack
  end
  
  def test_equip_sword
    c = Creature.new
    str = c.str
    
    c.equip(Item.load('sword'))
    
    #Still in limbo
    assert c.str > str
  end
  
  def test_equip_no_slot
    c = Creature.new
    item = Item.new('Badger', nil, {})
    
    #Item is returned because it was not equipped
    assert_equal c.equip(item), item
  end
  
  def test_apply_attack
    c = Creature.new
    attack = Attack.new(Creature.new)
    shield = Shield.random
    
    c.apply_attack(attack)
    c.equip(shield)
    c.apply_attack(attack)
    assert_equal shield, c.equip(Shield.random)
    c.apply_attack(attack)
  end

  def test_mm
    c = Creature.new
    val = c.str
    assert val
    
    begin
      c.this_is_not_a_method
    rescue
      assert true
    else
      assert false
    end
  end
end
