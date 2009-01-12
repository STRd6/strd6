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
  
  context "making a new game" do
    setup do
      @players = [Factory(:player), Factory(:player)]
      # These are used when creating instances in the game
      Factory :character
      Factory :item
      Factory :ability
    end
    
    should "make a new one if given players" do
      assert Game.make("A New Game", @players)
    end
    
    context "after a game is made" do
      setup do
        @game = Game.make("A New Game", @players)
      end
      
      should "Deal and assign cards to players " do
        @game.deal
        assert @game.cards_for_player(@players.first).size > 0
      end
    
      should "be able to move a character" do
        @game.move_character(@game.character_instances.first, [2,2])
      end
      
      should "be able to assign an ability to a character" do
        character_instance = @game.character_instances.first
        ability = @game.cards.abilities.first
        assert !character_instance.ability_cards.include?(ability)
        slot = Slot::ABILITY_1
        @game.assign_ability(character_instance, ability, slot)
        assert character_instance.ability_cards.include?(ability)
      end
      
      should "be able to assign a primary item to a character" do
        character_instance = @game.character_instances.first
        item = @game.cards.items.first
        assert_not_equal item, character_instance.primary_item_card
        slot = Slot::ITEM_PRIMARY
        @game.assign_ability(character_instance, item, slot)
        assert_equal item, character_instance.primary_item_card
      end
      
      should "be able to assign a secondary item to a character" do
        character_instance = @game.character_instances.first
        item = @game.cards.items.first
        assert_not_equal item, character_instance.secondary_item_card
        slot = Slot::ITEM_SECONDARY
        @game.assign_ability(character_instance, item, slot)
        assert_equal item, character_instance.secondary_item_card
      end
    end
  end
end
