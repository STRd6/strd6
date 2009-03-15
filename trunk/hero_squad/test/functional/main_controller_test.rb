require 'test_helper'

class MainControllerTest < ActionController::TestCase
  context "main" do
    should "have index" do
      get :index
      assert_response :success
    end
    
    should "have login" do
      get :login
      assert_response :success
    end    
  end
end
