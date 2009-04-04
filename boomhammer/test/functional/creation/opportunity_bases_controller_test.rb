require 'test_helper'

class Creation::OpportunityBasesControllerTest < ActionController::TestCase
  context "an opportunity base" do
    setup do
      Factory :item_base
      @opportunity_base = Factory :opportunity_base
    end

    should "GET index" do
      get :index
      assert_response :success
    end

    should "GET new" do
      get :new
      assert_response :success
    end

    should "GET show" do
      get :show, :id => @opportunity_base.id
      assert_response :success
    end
  end
end
