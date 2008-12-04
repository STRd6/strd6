class GamesController < ResourceController::Base
  actions :all, :except => [:destroy]
  
  create.before do
    players = Players.find params[:players]
    object.configure(params[:name], players)
  end
end
