class FeaturesController < ResourceController::Base
  include ObjectController
  
  def create
    build_object
    load_object
    before :create
    
    if (character = object.creator) && object.area
      if character.resources[:seeds] > 0
        if object.save
          character.resources[:seeds] -= 1
          character.save
          after :create
          set_flash :create
          response_for :create
          return
        end
      end
    end
    
    after :create_fails

    if request.xhr?
      render :update do |page|
        page.call :add_chat, "Oops, you're out of seeds!"
      end
    else
      render :nothing => true
    end
    
  end
end
