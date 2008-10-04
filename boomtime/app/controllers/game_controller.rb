class GameController < ApplicationController
  before_filter :login_required
  
  def index
    @active_character = current_user.active_character
    @area = @active_character.area
  end

  def feature_move
    feature = Feature.find(params[:id])
    
    feature.top = params[:top].to_i
    feature.left = params[:left].to_i
    
    feature.save
    
    render :juggernaut do |page|
      page.insert_html :bottom, 'chat_data', "<li>#{current_user} has moved a tree!</li>"
      page.visual_effect :move, "feature_#{feature.id}", {:x => feature.left, :y => feature.top, :mode => '"absolute"' }
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
