require 'test_helper'

class ActionsControllerTest < ActionController::TestCase
  context "logged in with a character" do
    setup do
      @character = Factory :character

      ActionsController.any_instance.stubs(:current_character).returns(@character)

      @opportunity = Factory :opportunity, :area => @character.area
    end

    should "be able to take an opportunity" do
      get :take_opportunity, {
        "opportunity_id" => @opportunity.id.to_s
      }
    end

    context "with an item" do
      setup do
        @item_base = Factory :item_base, :allowed_slot => Item::EquipSlot::Hands
        @item = @character.add_item_from_base(@item_base, 1)
      end

      context "equipped" do
        setup do
          @character.equip(@item, @item.allowed_slot)
        end

        should "be able to unequip the item" do
          assert_difference "@character.equipped_items.size", -1 do
            get :unequip_item, "item_id" => @item.id
            @character.reload
          end
        end
      end

      context "unequipped" do
        should "be able to equip the item" do
          assert_difference "@character.equipped_items.size", 1 do
            get :equip_item, "item_id" => @item.id, "item_slot" => @item.allowed_slot.index
            @character.reload
          end
        end
      end
    end
  end
end
