class QuizzesController < ResourceController::Base
  caches_page :show, :index
  
  before_filter :authenticate, :except => [ :show, :index ]
  
  index.before do
     @current_quiz = Quiz.current_quiz unless @current_quiz
  end
  
  show.before do
    @current_quiz = Quiz.current_quiz unless @current_quiz
    @quiz = Quiz.last unless @quiz
    @title = "#{@quiz.title} (#{@quiz.id})"
  end
  
  create.after do
    #expire_page formatted_quizzes_path :format => "rss"
  end
  
  index.wants.rss { render :type => :builder, :template => "index.rss.builder" }
end
