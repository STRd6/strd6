require 'test_helper'

class Creation::AreaLinksControllerTest < ActionController::TestCase
  context "an area link" do
    setup do
      Factory :intrinsic
      @area_link = Factory :area_link
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
      get :show, :id => @area_link.id
      assert_response :success
    end
  end
end
