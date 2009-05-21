class QuizzesController < ResourceController::Base
  caches_page :show, :index
  
  before_filter :login_required, :except => [ :show, :index ]
  
  index.before do
     @current_quiz = Quiz.current_quiz unless @current_quiz
  end
  
  show.before do
    @current_quiz = Quiz.current_quiz unless @current_quiz
    @quiz = Quiz.last unless @quiz
    @title = "#{@quiz.title} (#{@quiz.id})"
  end

  update.after do
    expire_page quiz_path(@quiz)
  end
  
  create.after do
    #TODO: We really should expire all pages here because the sidebar includes
    # all quizzes.
    expire_page quiz_path(@quiz)
    expire_page formatted_quizzes_path(:format => "rss")
  end
  
  index.wants.rss { render :type => :builder, :template => "index.rss.builder" }

  protected

  def collection
    Quiz.all :order => "id DESC"
  end
end
