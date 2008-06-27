require File.dirname(__FILE__) + '/test_helper.rb'

class RandomTest < Test::Unit::TestCase
  def test_array

    array = [0,1,2,3]

    10.times{ assert( (0..3) === array.random ) }

    array = []

    assert_equal array.random, nil

  end

  def test_round
    sum = 0
    num = 1.5
    times = 1000
    times.times{ sum += Rand::round(num) }
    puts sum
    assert_in_delta num*times, sum, 50

    sum = 0
    num = -1.5
    times.times{ sum += Rand::round(num) }
    puts sum
    assert_in_delta num*times, sum, 50

    sum = 0
    num = -0.01
    times.times{ sum += Rand::round(num) }
    puts sum
    assert_in_delta num*times, sum, 50
  end

  def test_gaussian
    rng = Rand.new
    puts
    15.times { puts( Rand::round(rng.gaussian * 1) )}
  end
end
