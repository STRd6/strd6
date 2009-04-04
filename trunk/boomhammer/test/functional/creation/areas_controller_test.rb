require 'test_helper'

class Creation::AreasControllerTest < ActionController::TestCase
  context "an area" do
    setup do
      Factory :area_base
      @area = Factory :area
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
      get :show, :id => @area.id
      assert_response :success
    end
  end
end

