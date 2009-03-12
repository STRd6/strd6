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
  
  def setup
    @game = object
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
    slot = params[:slot].to_i
    
    game.assign_card character, card, slot
    
    render :text => 'OK'
  end
  
  def character_action
    ability_index = params[:ability_index].to_i if params[:ability_index]
    ability_name = params[:ability_name]
    target = [params[:x], params[:y]]
    
    game = Game.find params[:id]
    character = CharacterInstance.find params[:character_instance][:id]
    
    ability = character.activated_abilities[ability_index] if ability_index
    
    # Check that ability is valid and that it is the ability that client believes it to be
    if ability && ability.name == ability_name
      results = character.perform_ability(ability, target)
    else
      error_message = "Character: #{character}\nAbility: #{ability}\n Ability Name: #{ability_name}"
      results = false
    end
    
    if results
      render :update do |page|
        results.each do |result|
          update_for page, result
        end
      end
    else
      render game_state_error(error_message)
    end
    
  end
  
  private
  def object
    @object ||= end_of_association_chain.find(params[:id], :include => [:cards, :character_instances, :entries])
  end
end
