class GamesController < ResourceController::Base
  actions :all, :except => [:destroy]
  
  create.before do
    players = Player.find params[:players]
    object.configure(params[:name], players)
  end
  
  show.before do
    @positions = Hash.new { |hash, key| hash[key] = [] }
    
    object.character_instances.each do |character|
      @positions[character.position] << character
    end
  end
  
  def move_character
    game = Game.find params[:id]
    character = CharacterInstance.find params[:token][:id]
    
    game.move_character character, [params[:x], params[:y]]
    
    if request.xhr?
      render :nothing => true
    else
      render :nothing => true
    end
  end
  
  def assign_card
    game = Game.find params[:id]
    
    character = CharacterInstance.find params[:character_instance][:id]
    card = Card.find params[:card][:id]
    slot = params[:slot]
    
    game.assign_card character, card, slot
  end
end
