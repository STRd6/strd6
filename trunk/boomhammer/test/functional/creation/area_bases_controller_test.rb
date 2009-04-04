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
  end
end