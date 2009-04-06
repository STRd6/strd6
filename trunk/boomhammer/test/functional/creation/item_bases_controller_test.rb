require 'test_helper'

class Creation::ItemBasesControllerTest < ActionController::TestCase
  context "an item_base" do
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
  end
end
