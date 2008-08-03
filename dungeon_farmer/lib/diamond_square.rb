class DiamondSquare
  def self.rando
    rand() - 0.5
  end
  
  def self.go(times)
    arrays = [[0.5]]
    
    ratio = 2
    
    times.times do
      arrays.map! do |array|
        insert_nils(array)
      end
      arrays = insert_arrays(arrays)
      compute_from_diagonals(arrays) {|a, b, c, d| (a + b + c + d)/4 + rando*ratio} #puts "%1.3f, %1.3f, %1.3f, %1.3f" % [a,b,c,d]; 
      compute_from_adjacents(arrays) {|a, b, c, d| (a + b + c + d)/4 + rando*ratio}
      ratio *= 0.5
    end
    
    return arrays
  end
  
  def self.insert_arrays(arrays)
    new_arrays = []
    arrays.size.times do |i|
      array = arrays[i]
      new_arrays.push array, Array.new(array.size, 0.0)
    end
    return new_arrays
  end
  
  def self.insert_nils(array)
    new_array = []
    array.size.times do |i|
      new_array.push(array[i], 0.0)
    end
    return new_array
  end
  
  def self.compute_from_adjacents(arrays)
    n = arrays.size
    n.times do |row|
      n.times do |col|
        next if (row + col) % 2 == 0
        arrays[row][col] = 
          yield(arrays[(row-1)%n][col], arrays[row][(col-1)%n],
                arrays[row][(col+1)%n], arrays[(row+1)%n][col])
      end
    end
  end
  
  def self.compute_from_diagonals(arrays)
    n = arrays.size
    n.times do |row|
      next if row % 2 == 0
      n.times do |col|
        next if col % 2 == 0
        arrays[row][col] = 
          yield(arrays[(row-1)%n][(col-1)%n], arrays[(row-1)%n][(col+1)%n],
                arrays[(row+1)%n][(col-1)%n], arrays[(row+1)%n][(col+1)%n])
      end
    end
  end
  
  def self.print_arrays(arrays)
    i = 0
    arrays.each do |array|
      print "%4d: " % i
      array.each do |ele|
        print '%1.3f ' % ele
      end
      i += 1
      puts
    end
    puts '---------------------------------------'
  end
end

if __FILE__ == $0
  require 'profiler'
  Profiler__::start_profile
  DiamondSquare.print_arrays(DiamondSquare.go(5))
  Profiler__::print_profile($>)
end