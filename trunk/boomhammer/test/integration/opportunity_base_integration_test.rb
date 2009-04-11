require 'test_helper'

class CharacterIntegrationTest < ActiveSupport::TestCase
  context "equally likely outcomes" do
    setup do
      @item_base1 = Factory :item_base
      @item_base2 = Factory :item_base

      @opportunity_base = Factory :opportunity_base

      @opportunity_base.events.create!(:base => @item_base1, :weight => 1)
      @opportunity_base.events.create!(:base => @item_base2, :weight => 1)

      @character = Factory :character
    end

    should "have approximately equal distribution of items" do
      100.times do
        @opportunity_base.generate_event.perform(@character)
      end

      item1_total = @character.items.find_by_item_base_id(@item_base1.id).quantity
      item2_total = @character.items.find_by_item_base_id(@item_base2.id).quantity

      assert item1_total > 33 && item1_total < 66
      assert item2_total > 33 && item2_total < 66
    end
  end
end