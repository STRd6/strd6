class Combat
  attr_reader :a, :b

  def initialize(a, b)
    @a, @b = a, b
    
    @sides = [@a, @b]
    
    s = -1
    @sides.each do |side|
      s = s + 1
      side.each {|creature| creature.side = s}
    end
    
    @combatants = @sides.flatten

    @cur = 0
  end

  def display
    @a.each {|c| puts c.describe}
    @b.each {|c| puts c.describe}
  end

  def turn
    unless @combatants[@cur].dead?
      attack = @combatants[@cur].get_attack

      targets = @combatants.reject {|combatant| combatant.side == @combatants[@cur].side || combatant.dead?}

      return false if targets.size == 0

      target = targets.random

      puts "#{@combatants[@cur].name} attacks #{target}"
      target.apply_attack attack
    end

    @cur = (@cur + 1) % @combatants.size

    return @combatants.any? {|combatant| !combatant.dead?}
  end

end
