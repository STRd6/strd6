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
  
  def character_action
    ability_id = params[:ability_id].to_i if params[:ability_id]
    ability_name = params[:ability_name]
    target = [params[:x], params[:y]]
    
    game = Game.find params[:id]
    character = CharacterInstance.find params[:character_instance][:id]
    
    ability = character.activated_abilities[ability_id] if ability_id
    
    # Check that ability is valid and that it is the ability that client believes it to be
    if ability && ability.name == ability_name
      if character.perform_ability(ability, target)
        # Success
        success = true
      else
        error_message = "Ability failed to perform"
        success = false
      end
    else
      error_message = "Character: #{character}\nAbility: #{ability}\n Ability Name: #{ability_name}"
      success = false
    end
    
    if success
      render :nothing => true
    else
      render game_state_error(error_message)
    end
    
  end
end
