class GameController < ApplicationController
  before_filter :login_required
  
  def index
    @active_character = current_user.active_character
    @area = @active_character.area
  end

  def feature_move
    valid_classes = [Character, Feature]
    
    klass = params[:class].camelize.constantize
    
    if valid_classes.include? klass
      element = klass.find(params[:id])
      
      element.top = params[:top].to_i
      element.left = params[:left].to_i
      element.save
        
      render :juggernaut do |page|
        page.insert_html :bottom, 'chat_data', "<li>#{current_user} has moved a #{klass}!</li>"
        page.call :scroll_chat
        page.visual_effect :move, "#{klass.to_s.downcase}_#{element.id}", {:x => element.left, :y => element.top, :mode => '"absolute"' }
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