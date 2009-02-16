class ScriptsController < ResourceController::Base
  actions :all, :except => [:destroy]
  protect_from_forgery :except => [:create]
  
  index.wants.js {render :json => @scripts}
  show.wants.js {render :json => @script}
end
