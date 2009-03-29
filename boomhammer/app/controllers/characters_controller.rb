class CharactersController < ResourceController::Base
  actions :all, :except => [:destroy]
  before_filter :login_required

  def collection
    @collection ||= current_account.characters
  end

  def object
    @object ||= current_account.characters.find(params[:id])
  end

  def build_object
    @object ||= current_account.characters.new object_params
  end

  def activate
    begin
      @character = current_account.characters.find(params[:id])
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
    flash[:notice] = current_character.take_opportunity(params[:opportunity_id])
  end

end
