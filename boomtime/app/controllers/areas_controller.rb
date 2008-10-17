class AreasController < ResourceController::Base
  actions :all, :except => [:destroy]
end
