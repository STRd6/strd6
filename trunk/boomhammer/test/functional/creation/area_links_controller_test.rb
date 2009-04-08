require 'test_helper'

class Creation::AreaLinksControllerTest < ActionController::TestCase
  context "an area link" do
    setup do
      @area1 = Factory :area
      @area2 = Factory :area
      Factory :intrinsic_base
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

    should "POST create without inverse link" do
      assert_difference "AreaLink.count" do
        post :create, "area_link" => {
          "create_inverse_link" => "0",
          "area_id" => @area1.id.to_s,
          "linked_area_id" => @area2.id.to_s
        }
        assert_response :redirect
      end
    end

    should "POST create with inverse link" do
      assert_difference "AreaLink.count", 2 do
        post :create, "area_link" => {
          "create_inverse_link" => "1",
          "area_id" => @area1.id.to_s,
          "linked_area_id" => @area2.id.to_s
        }
        assert_response :redirect
      end
    end
  end
end
