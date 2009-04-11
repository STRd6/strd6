require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "characters" do
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
  end
end
