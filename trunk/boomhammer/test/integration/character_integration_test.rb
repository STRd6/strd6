require 'test_helper'

class CharacterIntegrationTest < ActiveSupport::TestCase
  context "crafting a recipe with two equally likely outcomes" do
    setup do
      @ingredient = Factory :item_base

      @item_base1 = Factory :item_base
      @item_base2 = Factory :item_base

      assert @item_base1.id, "Precondition: Items saved sucessfully"
      assert @item_base2.id, "Precondition: Items saved sucessfully"
      
      @recipe = Recipe.new(:name => "Equi-outcome")
      @recipe.add_component(@ingredient, 1)
      @recipe.add_outcome(@item_base1, 1)
      @recipe.add_outcome(@item_base2, 1)
      @recipe.save!

      @character = Factory :character
      100.times do
        @character.add_item_from_base(@ingredient)
      end

      ingredients = @character.items.first :conditions => {:item_base_id => @ingredient.id}
      assert_equal 100, ingredients.quantity, "Precondition: 100 ingredients"
      # puts "#{ingredients.name}[#{ingredients.id}] => #{ingredients.quantity}"
    end

    should "have about equal outcomes" do
      100.times do
        @character.make_recipe(@recipe)
      end

      first_outcome = @character.items.first :conditions => {:item_base_id => @item_base1.id}
      second_outcome = @character.items.first :conditions => {:item_base_id => @item_base2.id}

      # puts @character.items.map {|i| "#{i.name}[#{i.id}] => #{i.quantity}"}

      assert first_outcome
      assert second_outcome

      assert first_outcome.quantity < 66 && first_outcome.quantity > 33, "Not guaranteed, just highly likely"
      assert second_outcome.quantity < 66 && second_outcome.quantity > 33, "Not guaranteed, just highly likely"

      assert_equal 100, first_outcome.quantity + second_outcome.quantity, "Total should add up to 100"
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

  context "crafting a recipe that requires tools" do
    setup do
      
    end
  end

  context "abilities from equipped items" do
    setup do
      @character = Factory :character

      @granted_ability = "darkness resistance"

      @item_base = Factory :item_base, :granted_abilities => [@granted_ability], :allowed_slot => Item::EquipSlots::HANDS
      @item = Factory :item, :item_base => @item_base, :owner => @character

      assert @item.granted_abilities.include?(@granted_ability)
    end

    should "have abilities granted by equipped items" do
      assert_equal false, @character.net_abilities.include?(@granted_ability)

      @character.equip(@item, @item.allowed_slot)
      #@character.reload

      assert @character.net_abilities.include?(@granted_ability)
    end
  end
end