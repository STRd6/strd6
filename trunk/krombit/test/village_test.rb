require File.dirname(__FILE__) + '/test_helper.rb'

class VillageTest < Test::Unit::TestCase
  def test_add_creature
    village = Village.new
    village.add_resident creature=Creature.new
    assert village.residents.include?(creature)
  end
  
  def test_add_item
    village = Village.new
    village.add_item item=Item.random
    assert village.items.include?(item)
  end
  
  def test_arm
    village = Village.new
    village.add_resident Creature.new
    village.add_item Item.random
    village.arm!    
  end
  
end
