class GameController < ApplicationController
  include Renderino
  before_filter :login_required, :except => [:observe]
  
  def index
    @active_character = current_user.active_character
    @area = @active_character.area
  end
  
  def observe
    #@active_character = current_user.active_character
    @area = Area.find(params[:id])
  end

  #
  # This is called when a player moves or places a displayable in an area.
  #
  def feature_move    
    klass = params[:class].camelize.constantize
    
    if valid_classes.include? klass
      element = klass.find(params[:id])
      
      #TODO: TOTAL HACK, be way more robust here
      if klass == Item
        logger.info "Iteam!"
        element.owner = active_character.area
        element.save
        area = element.owner
      else
        area = element.area
      end
      
      element.update_position(params[:left], params[:top])
      # Update all clients in area
      render_to_area area do |page|
        page.call :add_chat, "#{h current_user} has moved a #{klass}!"
        page.call 'game.updateDisplayable', element.css_id, element.left, element.top
      end
      render :nothing => true
    else
      render :text => 'Invalid Class', :status => 403
    end
  end
  
  #
  # This action is called when a player tries to pick up an item.
  # TODO: Move a lot of this code into models, it's getting way ugly
  #
  def get_item
    
    if active_character
      item = Item.find(params[:item][:id])
      position = params[:item][:container_position]
      
      # swap any existing item in same position
      prev_item = active_character.inventory.find(:first, :conditions => {:container_position => position})
      
      if item.owner == active_character
        if prev_item
          prev_item.container_position = item.container_position
          prev_item.save
        end
        
        item.container_position = position
        item.save
      elsif item.owner == active_character.area
        area = active_character.area
        
        if prev_item
          prev_item.owner = area
          prev_item.save
          
          render_to_area area do |page|
            page.call :add_chat, "#{h current_user} has dropped #{h prev_item.name}!"
            page.call 'game.updateDisplayable', prev_item.css_id, prev_item.left, prev_item.top
          end
        end
        
        item.owner = active_character
        item.container_position = position
        item.save
        # Update all clients in area
        render_to_area area do |page|
          page.call :add_chat, "#{h active_character.name} has picked up #{h item.name}!"
          page.call :got_item, item.css_id, active_character.id
        end
      end
    end
    
    render :nothing => true
  end
  
  # When player picks up a pile of resources
  def get_pile
    item = Item.find(params[:item][:id])
    
    # Add pile resources to player
    if active_character.get_pile(item)
      render_to_area active_character.area do |page|
        page.call :add_chat, "#{h active_character.name} has picked up #{h item.name}!"
        page.call :got_item, item.css_id, active_character.id
      end
      render :update do |page|
        page.replace 'active_character_data', :partial => 'components/active_character_data', :locals => {:active_character => active_character}
      end
    else
      render :update do |page|
        page.call 'game.updateDisplayable', item.css_id, item.left, item.top
      end
    end
  end
  
  #
  # This action is called by the client when it needs data about a
  # Displayable. Only updates the requesting client, no Juggernaut.
  #
  def get_displayable
    klass = params[:class].constantize
    
    if valid_classes.include? klass
      #TODO: Only get local items: active_character.area.items.find(params[:id])
      displayable = klass.find(params[:id]);
      render :partial => 'game/displayable_content', :locals => {:displayable => displayable}
    else
      render :text => 'Invalid Class', :status => 403
    end
  end
  
  #
  # This action is called when a character attempts to go to an area
  #
  def goto
    area = Area.find(params[:area_id])
    
    if area
      if old_area = active_character.area
        render_to_area old_area do |page|
          page.call :add_chat, "#{h active_character.name} has left the area."
          page.call 'game.removeDisplayable', active_character.css_id
        end
      end
          
      active_character.area = area
      active_character.save
      
      render_to_area area do |page|
        page.call :add_chat, "#{h active_character.name} has entered the area."
        page.call 'game.updateDisplayable',
          active_character.css_id, active_character.left, active_character.top
      end
    end
    
    render :nothing => true
  end
  
  def ability
    begin
      target = Feature.find(params[:target])
      new_item = active_character.perform_ability(params[:ability], target)

      if new_item
        render_to_area active_character.area do |page|
          page.call :add_chat, "#{h active_character.name} chopped some wood."
          page.call 'game.removeDisplayable', target.css_id
          page.call 'game.updateDisplayable',
            new_item.css_id, new_item.left, new_item.top
        end
      end
    rescue ActiveRecord::RecordNotFound
      
    end
    
    render :nothing => true
    
  end
  
  private
  def valid_classes 
    [Character, Feature, Item, Sign]
  end
end
