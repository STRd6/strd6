class CharactersController < ResourceController::Base
  actions :all, :except => [:destroy]
  before_filter :login_required

  def collection
    current_account_characters
  end

  def object
    current_account_characters.find(params[:id])
  end

  def build_object
    Character.new object_params.merge(:account => current_account)
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
    opportunity = current_character.area.opportunities.find(params[:id])
    flash[:notice] = current_character.take_opportunity(opportunity)
  end

  protected

  # Temporary workaround until a reliable way to add `has_many :characters` to `Account` is found
  def current_account_characters
    Character.for_account_id(current_account.id)
  end
end
