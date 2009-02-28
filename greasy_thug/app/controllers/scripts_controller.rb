class ScriptsController < ResourceController::Base
  actions :all, :except => [:destroy]
  protect_from_forgery :except => [:create]
  
  index.wants.json {render :json => @scripts}
  show.wants.json {render :json => @script}
end
