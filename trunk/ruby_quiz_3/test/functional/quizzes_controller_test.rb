require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  should "GET index" do
    get :index
    assert_response :success
  end
  
  context "a quiz" do
    setup do
      @quiz = Factory :quiz
    end
    
    should "GET show" do
      get :show, :id => @quiz.id
      assert_response :success
    end
  end
  
end
