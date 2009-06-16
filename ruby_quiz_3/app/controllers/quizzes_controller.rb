class QuizzesController < ResourceController::Base
  include AuthenticatedSystem
  
  caches_page :show, :index

  before_filter :login_required, :except => [ :show, :index ]
  
  index.before do
      @latest_quiz = Quiz.latest_quiz
      @current_quiz = Quiz.current_quiz
      @quiz = Quiz.all_live.first unless @quiz
      #@quizzes = Quiz.all_live unless session[:user_id]
    end
     
    show.before do
      @latest_quiz = Quiz.latest_quiz
      @current_quiz = Quiz.current_quiz
      #@quizzes = Quiz.all_live unless session[:user_id]
      @quiz = Quiz.all_live.first unless @quiz
      @title = @quiz.title_with_id
      #puts @quiz.to_yaml
    end
  
    update.after do
      remove_cache_files
      @quiz = Quiz.all_live.first
    end
     
    create.after do
      remove_cache_files
    end
    
    index.wants.rss { render :type => :builder, :template => "index.rss.builder" }

  private

  def collection
    Quiz.all_live :order => "id DESC" unless session[:user_id]
    Quiz.all :order => "id DESC"
  end
  
  def object
    @object ||= end_of_association_chain.find(param) unless param.nil?
    @object
  end
end
