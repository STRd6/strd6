class FeaturesController < ResourceController::Base
  include ObjectController
  
  create.before do
    object.creator = active_character
    object.area = active_character.area if active_character
    if params[:feature][:properties]
      logger.info params[:feature][:properties]
      object.properties = {:image => params[:feature][:properties][:image]}
      logger.info("OBJ: #{object.properties}")
    end
  end
end
