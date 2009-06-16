require 'test_helper'

class Admin::QuizzesControllerTest < ActionController::TestCase
  context "an unauthenticated user" do
     setup do
       @controller = Admin::QuizzesController.new
       @request    = ActionController::TestRequest.new
       @response   = ActionController::TestResponse.new
       
       @quiz = Factory(:quiz, :summary => "summary here", :live => true)
       @quiz_without_summary = Factory(:quiz, :summary => "")
     end
     
     should "GET index" do
       get :index
       assert_response :found
       assert_redirected_to new_session_path
     end
     
      should "GET show" do
        get :show, :id => @quiz.id
        assert_response :found
        assert_redirected_to new_session_path
      end
      
      should "redirect to login on update" do
        put :update, :id => @quiz.id
        assert_response :found
        assert_redirected_to new_session_path
      end
      
      should "redirect to login on delete" do
        post :delete, :id => @quiz.id
        assert_response :found
        assert_redirected_to new_session_path
      end
      
      should "redirect to login on create" do
        post :create, :id => @quiz.id
        assert_response :found
        assert_redirected_to new_session_path
      end
    end
    
    context "an authenticated user" do
      setup do
        @controller = Admin::QuizzesController.new
        @request    = ActionController::TestRequest.new
        @response   = ActionController::TestResponse.new
        @quiz = Factory :quiz
        login_as("quentin")
      end
      
      should "GET edit" do
        get :edit, :id => @quiz
        assert assigns(:quiz)
        assert_response :success
      end
      
      should "redirect to the right page after update" do
        put :update, :id => @quiz.id
        assert_response :found
        assert_redirected_to admin_quiz_path(@quiz.id)
      end
      
      should "redirect to the right page after create" do
        post :create, :title => "blah"
        assert_response :found
        assert assigns(:quiz)
        assert_redirected_to admin_quiz_path(assigns(:quiz))
      end
      
      should_eventually "test edit and update actions" do
        #check quiz variable
        #check redirects
      end
      
      teardown do
        logout
      end
    end
end
