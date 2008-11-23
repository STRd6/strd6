require 'test_helper'

class CardTest < ActiveSupport::TestCase
  context "a card" do
    setup do
      @card = Factory :card
    end
    
    should "reference an item or ability" do
      assert @card.item || @card.ability
    end
    
    should "belong to a game" do
      assert @card.game
    end
    
    should "have a name" do
      assert @card.name
    end
  end
end
