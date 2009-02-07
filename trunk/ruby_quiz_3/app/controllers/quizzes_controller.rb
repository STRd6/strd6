class QuizzesController < ResourceController::Base
  actions :show, :index
  
  caches_page :index, :show
  
  before_filter :authenticate, :except => [ :index , :show ]
  
  private
  
  def object
    if params[:id]
      Quiz.find(params[:id])
    else
      Quiz.last
    end
  end
end
