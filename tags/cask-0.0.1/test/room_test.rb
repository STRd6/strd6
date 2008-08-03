require File.dirname(__FILE__) + '/test_helper.rb'

class RoomTest < Test::Unit::TestCase
  def test_new
    assert Room.new
  end
end
