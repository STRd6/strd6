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
    
    teardown do
      Quiz.delete_all
    end
  end
  
  context "list of quizzes" do
    setup do
      @quiz_with_summary = Factory.create(:quiz, :summary => "blah blah", :live => true)
      @quiz_without_summary = Factory.create(:quiz)
      @quizzes_without_summary = Quiz.find(:all, :conditions => {:summary => ""}, :order => "created_at DESC")
      @latest_quiz = Quiz.find(:last, :conditions => {:live  => true})
      @current_quiz = Quiz.all_live.find(:last, :conditions => {:summary => ""})
    end
    
    should "respond to named_scope methods" do
      assert_respond_to(Quiz, :has_summary)
      assert_respond_to(Quiz, :blank_summary)
      assert_respond_to(Quiz, :latest_quiz)
      assert_respond_to(Quiz, :all_live)
    end
    
    should "provide quizzes with blank summaries" do
      assert_equal(@quizzes_without_summary, Quiz.blank_summary)
    end
    
    should "show only live quizzes" do   
       quizzes = Quiz.all_live
       live_quizzes = quizzes.select {|q| q.live == true }
       assert_equal(quizzes, live_quizzes)
    end
    
    should "provide current_quiz" do
      assert_equal(@current_quiz, Quiz.current_quiz)
    end
    
    should "provide latest_quiz" do
      assert_equal(@latest_quiz, Quiz.latest_quiz)
    end
    
    should "set the summary_date when a summary is added" do
      assert_nil(@quiz_without_summary.summary_date)

      @quiz_without_summary.summary = "hello world"
      @quiz_without_summary.save
      assert_not_nil(@quiz_without_summary.summary_date)
    end
    
    teardown do
      Quiz.delete_all
    end
  end
end
