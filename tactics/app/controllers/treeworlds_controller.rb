class TreeworldsController < ResourceController::Base
  show.wants.json { render :json => object.to_json(:include => :trees)}
end
