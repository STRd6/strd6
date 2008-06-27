require File.dirname(__FILE__) + '/test_helper.rb'

class GameTest < Test::Unit::TestCase
  def test_new
    assert game = Game.new
  end
end
