require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  setup do
    quiz = Factory :quiz
  end
  
  should "GET suggestions" do
    get :suggestions
    assert_response :success
    assert_generates("/suggestions", :controller  => "site", :action => 'suggestions')
  end
  
  should "GET about" do
    get :about
    assert_response :success
    assert assigns(:quiz)
    assert_kind_of(Quiz, assigns(:quiz))
  end
  
  teardown do
    Quiz.delete_all
  end
end