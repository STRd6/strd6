class GameController < ApplicationController
  before_filter :login_required
  
  def index
    @active_character = current_user.active_character
    @area = @active_character.area
  end

  def feature_move
    valid_classes = [Character, Feature, Item]
    
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
        page.insert_html :bottom, 'chat_data', "<li>#{current_user} has moved a #{klass}!</li>"
        page.call :scroll_chat
        page.visual_effect :move, "#{klass.to_s.downcase}_#{element.id}", {:x => element.left, :y => element.top, :mode => '"absolute"' }
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
      if item.owner == active_character.area
        item.owner = active_character
        item.save
      end
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
