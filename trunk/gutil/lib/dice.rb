class Fixnum
  def d(sides)
    sum = 0
    self.times {sum += Kernel.rand(sides) + 1}
    return sum
  end
end
