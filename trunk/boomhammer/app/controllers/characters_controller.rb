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

  def take_opportunity
    opportunity = current_character.area.opportunities.find(params[:id])
    notifications = current_character.take_opportunity(opportunity)

    flash[:game_notice] = render_to_string :partial => 'game/game_notifications', :object => notifications
    redirect_to current_character.area
  end

  def take_area_link
    area_link = current_character.area.area_links.find(params[:id])
    notifications = current_character.take_area_link(area_link)

    flash[:game_notice] = render_to_string :partial => 'game/game_notifications', :object => notifications
    redirect_to current_character.area
  end

  def make_recipe
    recipe = Recipe.find(params[:id])
    notifications = current_character.make_recipe recipe

    flash[:game_notice] = render_to_string :partial => 'game/game_notifications', :object => notifications
    redirect_to recipes_path
  end
end
