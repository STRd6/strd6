require 'test_helper'

class AuthStoriesTest < ActionController::IntegrationTest
  context "an authenticated user" do
    setup do
      
    end
  end

  def test_login_and_logout_paths
      get login_path
      assert_response :success
      
      get logout_path
      assert_response :found
    end
end
