class CharactersController < ResourceController::Base
  actions :all, :except => [:destroy]
  before_filter :login_required
  
  def collection
    @collection ||= current_user.characters
  end
  
  def object
    @object ||= current_user.characters.find(params[:id])
  end
  
  def build_object
    @object ||= current_user.characters.new object_params
  end
  
  def activate
    begin
      @character = current_user.characters.find(params[:id])
      current_user.active_character = @character
      
      if current_user.save
        flash[:notice] = "#{@character.name} activated!"
      else
        flash[:error] = "#{@character.name} NOT activated!"
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "NOT activated!"
    end
    
    redirect_to :action => 'index'
  end
  
end
