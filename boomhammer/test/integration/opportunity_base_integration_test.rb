require 'test_helper'

class CharacterIntegrationTest < ActiveSupport::TestCase
  context "equally likely outcomes" do
    setup do
      @item_base1 = Factory :item_base
      @item_base2 = Factory :item_base

      @opportunity_base = Factory :opportunity_base

      @opportunity_base.loots.create!(:item_base => @item_base1, :weight => 1)
      @opportunity_base.loots.create!(:item_base => @item_base2, :weight => 1)
    end

    should "have about equal distribution of outcomes" do
      item1_total = 0
      item2_total = 0

      100.times do
        @opportunity_base.generate_loot_item == @item_base1 ? item1_total += 1 : item2_total += 1
      end

      assert item1_total > 33 && item1_total < 66
      assert item2_total > 33 && item2_total < 66
    end
  end
end