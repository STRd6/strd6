require File.dirname(__FILE__) + '/test_helper.rb'

class ItemTest < Test::Unit::TestCase
  def test_new
    assert Item.new("dagger", :phand, {:str => 15, :dex => 10})
  end
  
  #TODO: This test is brittle
  def test_load
    assert item = Item.load('sword')
    assert item.str <= 45
    assert item.str >= 40
  end
  
  def test_attack
    creature = Creature.new
    
    Item.weapons.each do |weapon|
      
      item = Item.load(weapon)
      attack = item.get_attack(creature)
      
      total = 0
      num = 1000
      min = 1000000
      max = 0
      
      num.times do
        dmg = creature.dmg_reduce(attack.dmg)
        
        min = dmg if dmg < min
        max = dmg if dmg > max
        
        total += dmg
        
        attack.reset
      end
      
      avg = total.to_f/num
      
      puts "\n#{weapon}:"
      puts "avg: #{avg}"
      puts "min: #{min}"
      puts "max: #{max}"
      
      # Min should be at least zero
      assert min >= 0
    end
    
  end
  
  def test_fire_prot
    ring = Item.load 'ring_of_fire_protection'
    sword = Item.load 'fire_sword'
    
    creature = Creature.new
    
    creature.equip sword
    
    attack = creature.get_attack
    
    fire = attack.dmg[:fire]
    
    ring.notify('HIT', attack)
    
    assert fire > attack.dmg[:fire]
  end
  
  def test_block
    item = Item.load('sword')
    attack = item.get_attack(Creature.new)
    
    shield = Shield.load('steel_shield')
    # New shields don't start out broken
    assert !shield.broken?
    
    puts shield.stats_text
    assert_equal 200, shield.con
    
    # Shield will eventually block a standard attack
    blocked = false
    while !blocked do
      blocked = shield.blocks? attack
    end
    assert blocked
    
    # Destroy the shield
    shield.dmg_apply :blunt => 500
    assert shield.broken?
    
    # Shield should not block when broken
    100.times do 
      assert false if shield.blocks? attack
    end
  end
  
  
  #~ def test_reduction
    #~ item = Item.new('leather armor', :suit, {})
    
    #~ def item.notify(evt, attack, *args)
      #~ attack.dmg[:blunt] = [attack.dmg[:blunt] - 1, 0].max
    #~ end
    
    #~ attack = item.get_attack({:dex => 100})
    
    #~ armored = Creature.new('Armored')
    #~ armored.equip(item)
    #~ armored_dmg = 0
    
    #~ unarmored = Creature.new('Unarmored')
    #~ unarmored_dmg = 0
    
    #~ 50.times do
      #~ armored.apply_attack(attack)
      #~ armored_dmg += attack.dmg[:blunt]
      #~ attack.reset
      
      #~ unarmored.apply_attack(attack)
      #~ unarmored_dmg += attack.dmg[:blunt]
      #~ attack.reset
    #~ end
    
    #~ assert unarmored_dmg > armored_dmg
    
  #~ end
  
  def test_random_and_describe
    assert item=Item.random
    assert shield=Shield.random
    
    assert item.to_s.length > 0
    assert shield.to_s.length > 0
    
    assert item.describe.length > 0
    assert shield.describe.length > 0 
  end
  
end
