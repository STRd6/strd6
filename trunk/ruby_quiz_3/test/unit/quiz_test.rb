require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  context "a quiz" do
    setup do
      @quiz = Factory :quiz
    end

    should "have an author" do
      assert @quiz.author
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
  
  should "provide quizzes with blank summaries" do
    quiz_without_summary = Quiz.find(:first, :conditions => {:summary => ""}, :order => "created_at DESC")
    assert_equal(quiz_without_summary, Quiz.blank_summary.first)
    quiz_with_summary = Factory.create(:quiz, :summary => "blah blah")
    assert_equal(quiz_without_summary, Quiz.blank_summary.first)
  end
  
  should "provide current_quiz" do
    current_quiz = Factory.create(:quiz, :summary => "", :title => "q3")
    assert_equal(current_quiz, Quiz.current_quiz)
  end
  
  should "respond to named_scope methods" do
    assert_respond_to(Quiz, :has_summary)
    assert_respond_to(Quiz, :blank_summary)
    assert_respond_to(Quiz, :current_quiz)
  end
  
  should "set the summary_date when a summary is added" do
    #assert_respond_to(Quiz, :summary_date)
    quiz = Factory :quiz
    quiz.save
    assert_nil(quiz.summary_date)
    quiz.summary = "hello world"
    quiz.save
    assert_not_nil(quiz.summary_date)
  end
end
