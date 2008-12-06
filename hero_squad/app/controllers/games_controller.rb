class GamesController < ResourceController::Base
  actions :all, :except => [:destroy]
  
  create.before do
    players = Player.find params[:players]
    object.configure(params[:name], players)
  end
end
