require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context "a game with two players" do
    setup do
      # Create a game with two players
      @game = Factory :game
      @game.entries << Factory(:game_entry, :game => @game)
      @game.entries << Factory(:game_entry, :game => @game, :position => 1)
    end
    
    should "have a name" do
      assert @game.name
    end
    
    should "have two entries" do
      assert_equal 2, @game.entries.size
    end
    
    should "have two players" do
      assert_equal 2, @game.players.size
    end
  end
end
