class AnnotationsController < ResourceController::Base
  actions :all, :except => [:destroy]
  protect_from_forgery :except => [:create]
  
  index.wants.js {render :json => @annotations}
  show.wants.js {render :json => @annotation}
  
  private
  
  def collection
    Annotation.all :conditions => {:url => params[:url]}
  end
end
