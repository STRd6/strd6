require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  context "a player" do
    setup do
      @player = Factory :player
    end
    
    should "have a name" do
      assert @player.name
    end
  end
end
