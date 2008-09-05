class CharactersController < ResourceController::Base
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

end
