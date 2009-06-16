class QuizzesController < ResourceController::Base
  include AuthenticatedSystem
  
  caches_page :show, :index
  before_filter :login_required, :except => [ :show, :index ]
  actions :all, :except => [ :destroy, :update, :new, :edit, :create ]
  
   index.before do
      @latest_quiz = Quiz.latest_quiz
      @current_quiz = Quiz.current_quiz
      @quiz = Quiz.all_live.first unless @quiz
    end
     
    show.before do
      @latest_quiz = Quiz.latest_quiz
      @current_quiz = Quiz.current_quiz
      @quiz = Quiz.all_live.first unless @quiz
      @title = @quiz.title_with_id
    end

    index.wants.rss { render :type => :builder, :template => "index.rss.builder" }

    def edit
      redirect_to edit_admin_quiz_path(params[:id])
    end
  private

  def collection
    Quiz.all_live :order => "id DESC" unless session[:user_id]
    Quiz.all :order => "id DESC"
  end
end
