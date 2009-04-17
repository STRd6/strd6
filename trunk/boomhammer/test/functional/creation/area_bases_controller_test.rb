require 'test_helper'

class Creation::AreaBasesControllerTest < ActionController::TestCase
  context "an area_base" do
    setup do
      @area_base = Factory :area_base
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
      get :show, :id => @area_base.id
      assert_response :success
    end

    should "POST create" do
      assert_difference "AreaBase.count" do
        post :create, {
          "area_base"=>{
            "name"=>"test",
            "description" => "test",
          }
        }
      end
    end

    context "logged in" do
      setup do
        @account = Factory :account
        @controller.stubs(:current_account).returns(@account)
      end

      should "know the current account when creating an area base" do
        post :create, {
          "area_base"=>{
            "name"=>"test",
            "description" => "test",
          }
        }

        assert_equal @account, assigns(:area_base).account
      end
    end
  end
end