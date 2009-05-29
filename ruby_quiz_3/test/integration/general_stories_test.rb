require 'test_helper'

class GeneralStoriesTest  < ActionController::IntegrationTest
  context "Show a site page" do
    setup do
      Factory(:quiz, :summary => "Foo")
      Factory(:quiz, :title => "Blah", :summary => "Bar")
    end
    
    teardown do
      Quiz.delete_all
    end
    
    should "show the right number of quizzes in sidebar" do
      verify_sidebar_for_path("/about")
      verify_sidebar_for_path("/site/about")
    end
  end
  
  private
  
  def verify_sidebar_for_path(page)
    get page
    assert_response :success, "Cannot load #{page}"
    assert_equal(2, Quiz.has_summary.length)
    
    assert_select 'div#sidebar' do 
      assert_select 'ol' do
        assert_select 'li', 2
      end
    end
  end
end
