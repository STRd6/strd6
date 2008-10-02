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
    
    render :nothing => true
  end

end
