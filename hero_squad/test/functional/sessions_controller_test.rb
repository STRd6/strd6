require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  context "sessions" do
    should "have new" do
      get :new
      assert_response :success
    end
  end
end
