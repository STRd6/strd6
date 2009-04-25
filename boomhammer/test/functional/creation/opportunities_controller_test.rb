require 'test_helper'

class Creation::OpportunitiesControllerTest < ActionController::TestCase
  context "opportunity" do
    setup do
      @opportunity = Factory :opportunity
    end

    should "GET edit" do
      get :edit, :id => @opportunity.id
      assert_response :success
    end
  end
end
