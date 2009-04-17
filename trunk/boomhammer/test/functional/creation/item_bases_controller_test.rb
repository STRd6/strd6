require 'test_helper'

class Creation::ItemBasesControllerTest < ActionController::TestCase
  context "an item base" do
    setup do
      @item_base = Factory :item_base
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
      get :show, :id => @item_base.id
      assert_response :success
    end

    should "POST create" do
      assert_difference "ItemBase.count" do
        post :create, {
          "item_base"=>{
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

      should "know the current account when creating an item base" do
        post :create, {
          "item_base"=>{
            "name"=>"test",
            "description" => "test",
          }
        }

        assert_equal @account, assigns(:item_base).account
      end
    end
  end
end
