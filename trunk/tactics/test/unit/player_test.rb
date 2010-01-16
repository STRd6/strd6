require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  context "player" do
    setup do
      @player = Factory :player
    end

    should "be able to move around map edges" do
      @player.x = 0
      @player.y = 0
      @player.save

      assert @player.move_to(@player.x - 1, @player.y)
      assert @player.move_to(@player.x, @player.y - 1)
    end
  end
end
