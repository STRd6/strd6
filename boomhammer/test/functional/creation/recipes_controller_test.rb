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

    should "POST create" do
      assert_difference "Recipe.count" do
        post :create, {
          "recipe"=>{
            "name"=>"test",
          }
        }
      end
    end

    context "logged in" do
      setup do
        @account = Factory :account
        @controller.stubs(:current_account).returns(@account)
      end

      should "know the current account when creating a recipe" do
        post :create, {
          "recipe"=>{
            "name"=>"test",
          }
        }

        assert_equal @account, assigns(:recipe).account
      end
    end
  end
end
