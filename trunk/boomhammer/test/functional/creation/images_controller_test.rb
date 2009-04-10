require 'test_helper'

class Creation::ImagesControllerTest < ActionController::TestCase
  context "creation/images" do
    setup do
      Factory :image
    end
    
    should "GET index" do
      get :index
    end
  end
end
