module Attributed
  attr_reader :stats

  def initialize
    @stats = {}
  end
  
  def stats_text
    desc = "Stats:\n"
    stats.each {|key, value| desc += "  #{key}: #{value}\n"}
    return desc
  end

  def method_missing(name, *args)
    return stats[name] if stats.has_key? name
    super(name, *args)
  end
end

module Physical
  include Attributed

  def initialize(*args)
    super()
    stats.merge! :con => 0
  end

  def dmg_reduce(dmg)
    total = 0
    reduceable = 0
    
    dmg.each do |type, amt|
      total += amt
    end
    
    return total - 3*reduceable / 4
  end

  def dmg_apply(dmg)
    dmg = dmg_reduce(dmg)

    puts "#{@name} takes #{dmg} damage.".capitalize
    @hp -= dmg

    puts "#{@name} is destroyed!".capitalize if @hp <= 0
  end
end

class Creature
  include Physical, Observable
  
  @@data_dir = 'data/creatures/'
  
  attr_accessor :side
  attr_reader :name
  
  def initialize(name = "Human", hp = 100)
    super
    obs_init
    @name = name
    @hp_max = @hp = hp
    
    @inventory = []
    
    @item_slots = {:phand => nil,
                   :shand => nil, 
                   :head => nil, 
                   :suit => nil, 
                   :accessory => nil}
                   
    stats.merge!({:str => 100, :dex => 100, :con => 100})
    
    #equip(Item.random)
    #equip(Shield.random)
  end

  def to_s
    "#{@name}"
  end
  
  def get_attack
    return @item_slots[:phand].get_attack(self) if @item_slots[:phand]
    return Attack.new(self)
  end
  
  def apply_attack(attack)
    if(attack.hit? @stats)
      notify_listeners('HIT', attack)
      
      return unless attack.valid
      
      #TODO: Check Armor

      #Regular
      dmg_apply(attack.dmg)
    else
      puts "Missed!"
    end

  end
  
  def equip(item)
    if item && item.slot
      prev, @item_slots[item.slot] = @item_slots[item.slot], item
      
      add_listener(item)
      remove_listener(prev)
      puts "#{self} equips #{item}"
      return prev
    else
      return item
    end
  end

  def describe
    desc = "#{@name}: #{@hp}/#{@hp_max}\n"
    desc += stats_text
    desc += "Inventory:\n"
    @item_slots.each {|key, value| desc += "  #{key}: #{value}\n"}
    return desc
  end
  
  def dead?
    @hp <= 0
  end
  
  def [] (stat)
    if stats[stat]
      x = stats[stat]
    else
      x = 0
    end
    
    @item_slots.each_value do |item|
      if item
        x += item.bonus[stat] if item.bonus[stat]
      end
    end
    
    return x
  end
  
  def method_missing(name, *args)
    # TODO: Make this work for bonus stats that the creature doesn't have
    return self[name] if stats.has_key? name
    super(name, *args)
  end
end
