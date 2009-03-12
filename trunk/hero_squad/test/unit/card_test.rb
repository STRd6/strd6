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
  
  context "an ability card" do
    setup do
      @ability_card = Factory :card, :data => Factory(:ability)
    end
    
    should "be valid for ability slots" do
      assert @ability_card.valid_for?(Slot::ABILITY_1)
    end
    
    should "not be valid for item slots" do
      assert !@ability_card.valid_for?(Slot::ITEM_PRIMARY)
    end    
  end
end
