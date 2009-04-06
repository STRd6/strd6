class CharactersController < ResourceController::Base
  actions :all, :except => [:destroy]
  before_filter :login_required
  before_filter :character_required, :except => [:activate, :show, :index, :new, :edit, :update, :create]

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

      flash[:notice] = "#{@character.name} activated!"
      redirect_to current_character.area
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "NOT activated!"
      redirect_to :back
    end
  end
end
