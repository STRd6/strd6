require File.dirname(__FILE__) + '/test_helper.rb'

class AdventurerTest < Test::Unit::TestCase
  def test_new
    assert Adventurer.new(Room.new)
  end
end
