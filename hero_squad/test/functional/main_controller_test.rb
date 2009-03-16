require 'test_helper'

class MainControllerTest < ActionController::TestCase
  context "main" do
    setup do
      controller_setup
    end
    
    should "have index" do
      get :index
      assert_response :success
    end
  end
end
