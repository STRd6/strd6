class ItemsController < ResourceController::Base
  actions :all, :except => [:destroy]
end
