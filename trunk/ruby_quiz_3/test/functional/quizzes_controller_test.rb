require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  context "a couple quizzes" do
    setup do
      Factory(:quiz, :summary => "summary here")
      Factory(:quiz, :summary => "")
    end
    
    should "GET index" do
      get :index
      assert_response :success
      assert assigns(:current_quiz)
    end
  
    should "GET rss" do
      get :index, :format => "rss"
      assert_response :success
    end
    
    should "have current quiz" do
      get :index
      assert_response :success
      assert assigns(:current_quiz)
      assert_select 'h2', 'Current Quiz'
    end
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
    
  should "have autodiscoverable rss feed" do
      get :index
      assert_select "link[href=?]", /http:\/\/.*\/quizzes.rss/  
  end
end
