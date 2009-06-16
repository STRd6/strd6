require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  context "an unauthenticated user" do
    setup do
      @live_quiz = Factory(:quiz, :summary => "summary here", :live => true)
      @unlive_quiz = Factory(:quiz, :summary => "")
    end
    
    should "GET index" do
      get :index
      assert_response :success
      assert assigns(:latest_quiz)
    end
  
    should "GET rss" do
      get :index, :format => "rss"
      assert_response :success
    end
    
    should "GET show" do
      get :show, :id => @live_quiz.id
      assert_response :success
    end
    
    should "have current quiz" do
      q = Factory(:quiz, :live => true)
      get :index
      assert_response :success
      assert assigns(:latest_quiz)
      assert_select 'h2', 'Current Quiz'
      q.delete
    end
    
    should "not set active quiz if it is not live" do
      get :index
      assert_nil(assigns(:current_quiz))
    end
    
    should "not see quizzes that are not live" do
      get :index
      assert assigns(:quizzes)
      assigns(:quizzes).include?(@unlive_quiz)
    end
    
    should "redirect to login on update" do
      put :update, :id => @live_quiz.id
      assert_response :found
      assert_redirected_to new_session_path
    end
    
    should "redirect to login on delete" do
      post :delete, :id => @live_quiz.id
      assert_response :found
      assert_redirected_to new_session_path
    end
    
    should "redirect to login on create" do
      post :create, :id => @live_quiz.id
      assert_response :found
      assert_redirected_to new_session_path
    end
    
    should "have autodiscoverable rss feed" do
        get :index
        assert_select "link[href=?]", /http:\/\/.*\/quizzes.rss/  
    end
  end

  context "an authenticated user" do
    setup do
      @controller = QuizzesController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      @live_quiz = Factory(:quiz, :summary => "summary here", :live => true)
      login_as("quentin")
    end
  end
end
