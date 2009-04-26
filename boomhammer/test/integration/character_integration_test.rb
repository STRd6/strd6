require 'test_helper'

class CharacterIntegrationTest < ActiveSupport::TestCase
  context "crafting a recipe with two equally likely outcomes" do
    setup do
      @ingredient = Factory :item_base

      @item_base1 = Factory :item_base
      @item_base2 = Factory :item_base
      
      @recipe = Recipe.new(:name => "Equi-outcome")
      @recipe.add_component(@ingredient, 1)
      @recipe.add_event(@item_base1, 1)
      @recipe.add_event(@item_base2, 1)
      @recipe.save!

      @character = Factory :character
      10.times do
        @character.add_item_from_base(@ingredient)
      end

      @character.add_knowledge @recipe

      ingredients = @character.items.first :conditions => {:item_base_id => @ingredient.id}
      assert_equal 10, ingredients.quantity, "Precondition: 10 ingredients"
    end

    should "have about equal outcomes" do
      10.times do
        @character.make_recipe(@recipe)
      end

      first_outcome = @character.items.first :conditions => {:item_base_id => @item_base1.id}
      second_outcome = @character.items.first :conditions => {:item_base_id => @item_base2.id}

      assert first_outcome
      assert second_outcome

      assert first_outcome.quantity < 9 && first_outcome.quantity > 1, "Not guaranteed, just highly likely"
      assert second_outcome.quantity < 9 && second_outcome.quantity > 1, "Not guaranteed, just highly likely"

      assert_equal 10, first_outcome.quantity + second_outcome.quantity, "Total should add up to 10"
    end

    should "not succede without ingredients" do
      ingredients = @character.items.first :conditions => {:item_base_id => @ingredient.id}
      ingredients.quantity = 0
      ingredients.save!

      @character.make_recipe(@recipe)

      first_outcome = @character.items.first :conditions => {:item_base_id => @item_base1.id}
      second_outcome = @character.items.first :conditions => {:item_base_id => @item_base2.id}

      assert_equal nil, first_outcome
      assert_equal nil, second_outcome
    end
  end

  context "crafting a recipe that requires an ability" do
    setup do
      @ingredient = Factory :item_base
      @outcome = Factory :item_base
      @requisite = Factory :intrinsic_base

      @recipe = Recipe.new :name => "ability required",
        :intrinsic_base_ids => [@requisite.id]
      @recipe.add_component(@ingredient, 1, 100)
      @recipe.add_event(@outcome, 1)
      @recipe.save!

      @character = Factory :character,
        :intrinsic_base_id => @requisite.id
      @character.add_item_from_base(@ingredient)

      @character.add_knowledge @recipe
    end

    should "succede when character has required ability" do
      @character.make_recipe(@recipe)
      outcome = @character.items.first :conditions => {:item_base_id => @outcome.id}
      assert_equal 1, outcome.quantity
    end

    should "not succede when character does not have required ability" do
      @character.intrinsics.destroy_all

      @character.make_recipe(@recipe)
      outcome = @character.items.first :conditions => {:item_base_id => @outcome.id}
      assert_equal nil, outcome
    end
  end

  context "crafting a recipe that requires a tool" do
    setup do
      @ingredient = Factory :item_base
      @tool = Factory :item_base

      @outcome = Factory :item_base

      @recipe = Recipe.new(:name => "Tool involved")
      @recipe.add_component(@ingredient, 1, 100)
      @recipe.add_component(@tool, 1, 0)
      @recipe.add_event(@outcome, 1)
      @recipe.save!

      @character = Factory :character
      10.times do
        @character.add_item_from_base(@ingredient)
      end
      @character.add_item_from_base(@tool)

      @character.add_knowledge @recipe

      ingredients = @character.items.first :conditions => {:item_base_id => @ingredient.id}
      assert_equal 10, ingredients.quantity, "Precondition: 10 ingredients"

      tool = @character.items.first :conditions => {:item_base_id => @tool.id}
      assert_equal 1, tool.quantity, "Precondition: 1 tool"
    end
    
    should "be able to reuse tool" do
      10.times do
        @character.make_recipe(@recipe)
      end

      outcome = @character.items.first :conditions => {:item_base_id => @outcome.id}
      assert_equal 10, outcome.quantity

      tool = @character.items.first :conditions => {:item_base_id => @tool.id}
      assert_equal 1, tool.quantity, "tool remains"

      ingredients = @character.items.first :conditions => {:item_base_id => @ingredient.id}
      assert_equal 0, ingredients.quantity, "ingredients gone"
    end
  end

  context "character with abilities from equipped items" do
    setup do
      @character = Factory :character

      @intrinsic_base = Factory :intrinsic_base

      @item_base = Factory :item_base, :allowed_slot => Item::EquipSlots::HANDS
      @item_base.granted_abilities.create! :intrinsic_base => @intrinsic_base

      @item = Factory :item, :item_base => @item_base, :owner => @character

      assert @item.granted_abilities.map(&:intrinsic_base).include?(@intrinsic_base)
    end

    should "have abilities granted by equipped items" do
      assert_equal false, @character.net_abilities.map(&:intrinsic_base).include?(@intrinsic_base)

      @character.equip(@item, @item.allowed_slot)

      assert @character.net_abilities.map(&:intrinsic_base).include?(@intrinsic_base)
    end
  end
end