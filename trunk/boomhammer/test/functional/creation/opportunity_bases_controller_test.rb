require 'test_helper'

class Creation::OpportunityBasesControllerTest < ActionController::TestCase
  context "an opportunity base" do
    setup do
      Factory :item_base
      Factory :area_base
      Factory :event_base
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

    should "POST create" do
      assert_difference "OpportunityBase.count" do
        post :create, {
          "opportunity_base"=>{
            "name"=>"test",
            "description"=>"test"
          }
        }
      end
    end

    context "logged in" do
      setup do
        @account = Factory :account
        @controller.stubs(:current_account).returns(@account)
      end

      should "know the current account when creating an opportunity base" do
        post :create, {
          "opportunity_base"=>{
            "name"=>"test",
            "description"=>"test"
          }
        }

        assert_equal @account, assigns(:opportunity_base).account
      end
    end
  end
end
