require 'test_helper'

class AuthStoriesTest < ActionController::IntegrationTest
  fixtures :all

  context "admin user" do
    setup do
      user = Factory.build(:user)
      @quiz = Factory(:quiz)        
      post_via_redirect session_path, :remember_me => "1", :login => user.login, :password => user.password
      assert_equal("/", path)
      assert_equal 'Logged in successfully', flash[:notice]
    end
    
    should "see edit link" do
      get quizzes_path
      assert_select "a", {:text => "edit"}
    end
    
    teardown do      
      Quiz.delete_all
    end
  end
  
  context "anon user" do
    setup do
       @quiz = Factory(:quiz)
    end
    
    should "not see edit link" do
      get quizzes_path
      assert_select "a", {:text => "edit", :count => 0}
    end
    
    teardown do
      Quiz.delete_all
    end
  end
  
  # def test_login_and_logout_paths
  #     get login_path
  #     assert_response :success
  #     
  #     get logout_path
  #     assert_response :found
  #   end
  #   
  #   def test_admin_can_edit_site
  #     get login_path
  #     assert_response :success
  # 
  #     user = Factory.build(:user)
  #         
  #     post_via_redirect session_path, :remember_me => "1", :login => user.login, :password => user.password
  #     assert_equal("/", path)
  #     assert_equal 'Logged in successfully', flash[:notice]
  #     
  #     get new_quiz_path
  #     assert_response :success
  #     
  #     quiz = Factory.build(:quiz)
  #     post_via_redirect quizzes_path, :author => quiz.author, :title => quiz.title, :description => quiz.description
  #     assert_response :success
  #     assert assigns(:quiz)
  #     assert_equal(quiz_path(assigns(:quiz).id), path)
  #     assert_equal("Successfully created!", flash[:notice])
  #   end
  #   
  #   def test_anon_cannot_edit_site
  #     get logout_path
  #     assert_response :found
  #     
  #     quiz = Factory.build(:quiz)
  #     post quizzes_path, :author => quiz.author, :title => quiz.title, :description => quiz.description
  #     assert_response :found
  #     follow_redirect!
  #     assert_equal(new_session_path, path)
  #   end
end
