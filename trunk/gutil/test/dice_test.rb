require File.dirname(__FILE__) + '/test_helper.rb'

class DiceTest < Test::Unit::TestCase
  def test_rolls
    assert 1.d(6) > 0
    assert 1.d(6) < 7
    
    assert 2.d(6) < 13
    assert 2.d(6) > 1
  end
end
