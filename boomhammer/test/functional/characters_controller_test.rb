require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "when logged in" do
    setup do
      @current_account = Factory :account
      CharactersController.any_instance.stubs(:login_required)
      CharactersController.any_instance.stubs(:current_account).returns(@current_account)
      @intrinsic_base = Factory :intrinsic_base
      Factory :area, :starting_location => true
    end

    should "GET new" do
      get :new
    end

    should "be able to create a new character" do
      assert_difference "Character.count" do
        post :create, "character" => {
          "name" => "AUEA",
          "intrinsic_base_id" => @intrinsic_base.id
        }
      end
    end

    context "with a character" do
      setup do
        @character = Factory :character, :account => @current_account
        @character.add_item_from_base(Factory(:item_base), 1)
      end

      should "GET show" do
        get :show, :id => @character.id
      end
    end
  end
end
