require 'test_helper'

class AuthStoriesTest < ActionController::IntegrationTest
  fixtures :all

  def test_login_and_logout_paths
    get login_path
    assert_response :success
    
    get logout_path
    assert_response :found
  end
  
  def test_admin_can_edit_site
    get login_path
    assert_response :success

    user = Factory.build(:user)
        
    post_via_redirect session_path, :remember_me => "1", :login => user.login, :password => user.password
    assert_equal("/", path)
    assert_equal 'Logged in successfully', flash[:notice]
    
    get new_quiz_path
    assert_response :success
    
    quiz = Factory.build(:quiz)
    post_via_redirect quizzes_path, :author => quiz.author, :title => quiz.title, :description => quiz.description
    assert_response :success
    assert_equal(quiz_path(1), path)
    assert_equal("Successfully created!", flash[:notice])
  end
  
  def test_anon_cannot_edit_site
    get logout_path
    assert_response :found
    
    quiz = Factory.build(:quiz)
    post quizzes_path, :author => quiz.author, :title => quiz.title, :description => quiz.description
    assert_response :found
    follow_redirect!
    assert_equal(new_session_path, path)
  end
end
