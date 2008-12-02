class Fixnum
  # 3d6 => 3.d(6) roll one six sided die for each value.
  def d(sides)
    sum = 0
    self.times {sum += Kernel.rand(sides) + 1}
    return sum
  end
end