require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  should "GET suggestions" do
    get :suggestions
    assert_response :success
    assert_generates("/suggestions", :controller  => "site", :action => 'suggestions')
  end
end