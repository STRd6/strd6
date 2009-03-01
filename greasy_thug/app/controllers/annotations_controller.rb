class AnnotationsController < ResourceController::Base
  actions :all, :except => [:destroy]
  protect_from_forgery :except => [:create, :update]
  
  before_filter :find_api_user
  
  create.before do
    object.owner = @api_user if @api_user
  end
  
  index.wants.json {render :json => @annotations}
  show.wants.json {render :json => @annotation}
  
  private
  
  def collection
    Annotation.all :conditions => {:url => params[:url], :owner_id => [0, @api_user]}
  end
  
  def find_api_user
    @api_user = User.find_by_api_key(params[:api_key])
  end
end
