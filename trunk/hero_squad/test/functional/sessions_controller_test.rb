require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  context "sessions" do
    setup do
      controller_setup
    end
    
    should "have new" do
      get :new
      assert_response :success
    end
  end
end
