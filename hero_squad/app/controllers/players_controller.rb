class PlayersController < ResourceController::Base
  actions :all, :except => [:destroy]
end