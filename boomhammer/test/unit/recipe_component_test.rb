require 'test_helper'

class RecipeComponentTest < ActiveSupport::TestCase
  context "a consumable component" do
    setup do
      @recipe_component = Factory :recipe_component, :consume_percentage => 100
    end

    should "always be consumed" do
      assert @recipe_component.consume?
    end
  end

  context "a durable component" do
    setup do
      @recipe_component = Factory :recipe_component, :consume_percentage => 0
    end

    should "never be consumed" do
      assert_equal false, @recipe_component.consume?
    end
  end

  context "a rarely consumed component" do
    setup do
      @recipe_component = Factory :recipe_component, :consume_percentage => 1
    end

    should "rarely be consumed" do
      was_consumed = (0..9000).inject(@recipe_component.consume?){|memo, obj| memo || @recipe_component.consume?}
      assert_equal true, was_consumed
    end
  end

  context "a frequently consumed component" do
    setup do
      @recipe_component = Factory :recipe_component, :consume_percentage => 99
    end

    should "frequently be consumed" do
      was_consumed = (0..7).inject(@recipe_component.consume?){|memo, obj| memo || @recipe_component.consume?}
      assert_equal true, was_consumed
    end
  end
end
