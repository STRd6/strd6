class CharactersController < ResourceController::Base
  actions :all, :except => [:destroy]
  before_filter :login_required

  def collection
    current_account_characters
  end

  def object
    @object ||= current_account_characters.find(params[:id])
  end

  def build_object
    return @object if @object
    attributes = (object_params || {}).merge!(:account => current_account)
    @object = Character.new attributes
  end

  def activate
    begin
      @character = current_account_characters.find(params[:id])
      self.current_character = @character

      if current_account.save
        flash[:notice] = "#{@character.name} activated!"
      else
        flash[:error] = "#{@character.name} NOT activated!"
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "NOT activated!"
    end

    redirect_to :action => 'index'
  end

  def take_opportunity
    if current_character
      opportunity = current_character.area.opportunities.find(params[:id])
      flash[:notice] = current_character.take_opportunity(opportunity)
    else
      flash[:error] = "Please activate a character!"
      redirect_to characters_path
    end
  end
end
