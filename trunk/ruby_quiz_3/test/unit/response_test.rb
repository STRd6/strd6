require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  context "a response" do
    setup do
      @response = Factory :response
    end
    
    should "belong to a quiz" do
      assert @response.quiz
    end
    
    should "have an author" do
      assert @response.author
    end
    
    should "have a body" do
      assert @response.body
    end
  end
end
