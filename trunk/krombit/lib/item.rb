class Item
  include Physical
  attr_reader :slot, :enchantedness, :base_damage, :name, :bonus
  
  @@data_dir = 'data/items/'
  
  @@weapons = %w{sword dagger club pike fire_sword}
  
  def initialize(name, slot, bonus, dmg_exprs = {:blunt => '1.d(2)'}, notifications = {})
    super()
    @hp = 1
    @name = name
    @enchantedness = 0
    @slot = slot
    @bonus = bonus
    @dmg_exprs = dmg_exprs
    @notifications = notifications
  end

  def to_s
    name
  end
  
  def describe
    "#{@name}: #{@bonus}"
  end

  def get_attack(owner)
    return Attack.new(owner, @dmg_exprs)
  end
  
  def self.load(name)
    data = YAML::load(IO.read( @@data_dir + name + '.yml' ))
    notifications = data['notifications'] ? data['notifications'] : {} 
    return self.new(data['name'], data['slot'], data['bonus'], data['dmg_exprs'],  notifications)
  end
  
  def self.random
    return self.load(@@weapons.random)
  end
  
  def notify(evt, *args)
    #TODO: Lock for thread safety
    @attack = args[0]
    
    eval @notifications[evt] if @notifications[evt]
    
    @attack = nil
  end
  
  def reduce(type, amt)
    @attack.dmg[type] = [@attack.dmg[type] - amt, 0].max if @attack.valid && @attack.dmg[type]
  end
  
  def method_missing(name, *args)
    return @bonus[name] if @bonus.has_key? name
    super(name, *args)
  end
  
  def self.weapons
    return @@weapons
  end
  
end

class Shield < Item
  @@shields = %w{wood_shield steel_shield}
  
  def initialize(name, slot, bonus, stats)
    super(name, slot, bonus, {:blunt => '1.d(6) + str/20'})
    @hp = @hp_max = dur
    
    self.stats.merge! stats
  end

  def to_s
    "#{@name}: #{@hp}/#{@hp_max}"
  end

  def blocks?(attack)
    return rand(100) <= blk unless broken?
    return false
  end

  def broken?
    return @hp <= 0
  end
  
  def describe
    text = "#{name}:\n"
    text += stats_text
    return text
  end
  
  def notify(evt, attack, *args)
    return unless attack.valid
    
    if blocks?(attack)
      puts "#{@name} blocks the attack!".capitalize
      dmg_apply attack.dmg
      
      attack.valid = false
    end
    
  end
  
  def self.load(name)
    data = YAML::load(IO.read( @@data_dir + name + '.yml' ))
    
    return self.new(data['name'], data['slot'], data['bonus'], data['stats'])
  end
  
  def self.random
    return self.load(@@shields.random)
  end
end

