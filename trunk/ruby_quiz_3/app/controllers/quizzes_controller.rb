class QuizzesController < ResourceController::Base
  caches_page :show, :index
  
  before_filter :authenticate, :except => [ :show, :index ]
  
  show.before do
    @quiz = Quiz.last unless @quiz
    @title = "#{@quiz.title} (#{@quiz.id})"
  end
end
