class QuizzesController < ResourceController::Base
  actions :show, :index
  
  private
  
  def object
    if params[:id]
      Quiz.find(params[:id])
    else
      Quiz.last
    end
  end
end
