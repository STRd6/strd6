require 'test_helper'

class GameIntegrationTest < ActiveSupport::TestCase
  context "making a game" do
    setup do
      3.times do
        Factory :character
        Factory :item
        Factory :ability
      end
    end
    
    should "complete successfully" do
      game = Game.make("Test Game", [Factory(:player), Factory(:player)])
      
      assert !game.new_record?
      assert game.cards.size > 1
      assert game.players.size > 1
      assert game.entries.size > 1
      assert game.entries.size == game.players.size
      assert game.character_instances.size > 1
    end
  end
end