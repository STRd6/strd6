class GameController < ApplicationController
  before_filter :login_required
  
  def index
    @active_character = current_user.active_character
    @area = @active_character.area
  end

  def feature_move
    valid_classes = [Character, Feature, Item, Sign]
    
    klass = params[:class].camelize.constantize
    
    if valid_classes.include? klass
      element = klass.find(params[:id])
      
      #TODO: TOTAL HACK, be way more robust here
      if klass == Item
        logger.info "Iteam!"
        element.owner = active_character.area
        element.save
      end
      
      element.update_position(params[:left], params[:top])
        
      render :juggernaut do |page|
        page.call :add_chat, "#{h current_user} has moved a #{klass}!"
        page.visual_effect :move, element.css_id, {:x => element.left, :y => element.top, :mode => '"absolute"' }
      end
      render :nothing => true
    else
      render :text => 'Invalid Class'
    end
  end
  
  def get_item
    #TODO add inventory positioning
    if active_character
      item = Item.find(params[:item][:id])
      if item.owner != active_character && item.owner == active_character.area
        item.owner = active_character
        item.save
        render :juggernaut do |page|
          page.call :add_chat, "#{h active_character.name} has picked up #{h item.name}!"
          page.call :got_item, item.css_id, active_character.id
        end
      end
    end
    
    render :nothing => true
  end
  
  def get_displayable
    #TODO: Only get local items: active_character.area.items.find(params[:id])
    item = Item.find(params[:id])
    
    element = render_to_string :partial => 'game/displayable_content', :locals => {:displayable => item}
    
    render :juggernaut do |page|
      
      page.insert_html :top, 'game', element
      page.draggable item.css_id, :revert => 'drag_revert', :onStart => 'drag_start'
    end
    
    render :nothing => true
  end
  
  def goto
    active_character = current_user.active_character
    active_character.area_id = params[:area_id].to_i
    active_character.save
    render :nothing => true
  end

end
