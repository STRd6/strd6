class GameController < ApplicationController
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
      render :juggernaut => {:type => :send_to_channels, :channels => [area.channel]} do |page|
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
  #
  def get_item
    #TODO add inventory positioning
    if active_character
      item = Item.find(params[:item][:id])
      if item.owner != active_character && item.owner == active_character.area
        area = active_character.area
        item.owner = active_character
        item.save
        # Update all clients in area
        render :juggernaut => {:type => :send_to_channels, :channels => [area.channel]} do |page|
          page.call :add_chat, "#{h active_character.name} has picked up #{h item.name}!"
          page.call :got_item, item.css_id, active_character.id
        end
      end
    end
    
    render :nothing => true
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
      render :text => 'Invalid Clas', :status => 403
    end
  end
  
  #
  # This action is called when a character attempts to go to an area
  #
  def goto
    active_character = current_user.active_character
    active_character.area_id = params[:area_id].to_i
    active_character.save
    render :nothing => true
  end
  
  private
  def valid_classes 
    [Character, Feature, Item, Sign]
  end

end
