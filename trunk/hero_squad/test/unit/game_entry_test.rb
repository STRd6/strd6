require 'test_helper'

class GameEntryTest < ActiveSupport::TestCase
  context "a game entry" do
    setup do
      @entry = Factory :game_entry
    end
    
    should "have a player" do
      assert @entry.player
    end
    
    should "have a game" do
      assert @entry.game
    end
    
    should "have a position in the game" do
      assert @entry.position
    end
  end
end
