require 'test_helper'

class GeneralStoriesTest  < ActionController::IntegrationTest
  context "When viewing a site page it" do
    setup do
      Factory(:quiz, :summary => "Foo", :live => true)
      Factory(:quiz, :title => "Blah", :summary => "Bar", :live => true)
    end
    
    teardown do
      Quiz.delete_all
    end
    
    should "show the right number of quizzes in sidebar" do
      verify_sidebar_for_path("/about")
      verify_sidebar_for_path("/site/about")
    end
    
    should "GET /" do
      get root_path
      assert_response :success
      assert assigns(:quiz)
      assert_kind_of(Quiz, assigns(:quiz))
    end
  end
  
  private
  
  def verify_sidebar_for_path(page)
    get page
    assert_response :success, "Cannot load #{page}"
    #assert_equal(2, Quiz.has_summary.length)
    
    assert_select 'div#sidebar' do 
      assert_select 'ol#archives' do
        assert_select 'li', 2
      end
    end
  end
end
