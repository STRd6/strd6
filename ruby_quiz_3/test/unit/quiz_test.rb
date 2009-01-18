require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  context "a quiz" do
    setup do
      @quiz = Factory :quiz
    end
    
    should "have a title" do
      assert @quiz.title
    end
    
    should "have a description" do
      assert @quiz.description
    end
    
    should "have a posted date" do
      assert @quiz.posted
    end
    
    should "have many responses" do
      assert @quiz.responses
    end
  end
end
