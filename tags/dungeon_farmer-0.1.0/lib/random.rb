module Random
  def random
    return self[rand(length)]
  end
end

class Rand
  def initialize
    @use_last = false
  end

  def self.round (float)
    bottom = float.floor
    rem = float - bottom
    
    if rem > rand()
      return bottom + 1
    else
      return bottom
    end
  end

  def self.d(dice, sides)
    sum = 0
    dice.times {sum += Kernel.rand(sides) + 1}
    return sum
  end

  # Uses the polar form of the Box-Muller transformation which
  # is both faster and more robust numerically than basic Box-Muller
  # transform. To speed up repeated RNG computations, two random values
  # are computed after the while loop and the second one is saved and
  # directly used if the method is called again.
  # see http://www.taygeta.com/random/gaussian.html
  # returns single normal deviate
  def gaussian
    if @use_last
      y1 = @last
      @use_last = false
    else
      w = 1
      until w < 1.0 do
        x1 = (2.0 * Kernel.rand) - 1.0
        x2 = (2.0 * Kernel.rand) - 1.0
        w  = x1 * x1 + x2 * x2
      end
      w = Math.sqrt( (-2.0 * Math.log(w)) / w )
      y1 = x1 * w
      @last = x2 * w
      @use_last = true
    end
    return y1
  end
end

class Array
  include Random
end
