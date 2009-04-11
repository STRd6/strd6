require 'test_helper'

class Creation::RecipesControllerTest < ActionController::TestCase
  context "creation/recipes" do
    setup do
      @recipe = Factory.build :recipe
      @recipe.add_component Factory(:item_base), 1, 100
      @recipe.add_event Factory(:item_base)
      @recipe.save!
    end

    should "GET index" do
      get :index
    end
  end
end
