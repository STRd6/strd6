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
  end
end
