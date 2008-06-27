class Attack
  @@rng = Rand.new
  
  attr_accessor :valid, :dmg

  def initialize(owner, dmg_exprs = {:blunt => "1.d(6)", :pierce => "1.d(4)"})
    @owner = owner
    @dmg_exprs = dmg_exprs
    
    reset
  end
  
  def reset
    @dmg = generate_dmg
    @valid = true
  end
  
  def generate_dmg
    damages = {}
    
    @dmg_exprs.each do |type, expr|
      damages[type] = @owner.instance_eval(expr)
    end
    
    return damages
  end

  def hit?(target_stats)
    return rando(@owner[:dex] * 2) > rando(target_stats[:dex])
  end

  def rando(n)
    return [Rand::round(@@rng.gaussian * n) + n, 0].max
  end

end
