require 'test_helper'

class GameIntegrationTest < ActiveSupport::TestCase
  context "making a game" do
    # Create some background data for the game
    setup do
      3.times do
        Factory :character
        Factory :item
        Factory :ability
      end
    end
    
    should "complete setup successfully" do
      game = Game.make("Test Game", [Factory(:player), Factory(:player)])
      
      assert !game.new_record?
      assert game.cards.size > 1
      assert game.players.size > 1
      assert game.entries.size > 1
      assert game.entries.size == game.players.size
      assert game.character_instances.size > 1
    end
    
    should "deal out cards" do
      game = Game.make("Test Game", [Factory(:player), Factory(:player)])
      
      game.cards.each do |card|
        assert_equal nil, card.owner
      end
      
      game.deal
      game.reload
      
      game.cards.each do |card|
        assert card.owner
      end
      
      players = game.players
      
      # The first player should have the same amout of cards or one more
      assert game.cards_for_player(players[0]).size == game.cards.for_player(players[1]).size ||
        game.cards_for_player(players[0]).size == game.cards.for_player(players[1]).size + 1
    end
  end
end