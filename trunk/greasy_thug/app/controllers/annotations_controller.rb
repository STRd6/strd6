class AnnotationsController < ResourceController::Base
  actions :all, :except => [:destroy]
  protect_from_forgery :except => [:create, :update]
  
  index.wants.json {render :json => @annotations}
  show.wants.json {render :json => @annotation}
  
  private
  
  def collection
    Annotation.all :conditions => {:url => params[:url], :owner_id => params[:owner]}
  end
end
