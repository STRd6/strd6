class FeaturesController < ResourceController::Base
  include ObjectController
  
  create.wants.js do
    element = render_to_string :partial => 'game/displayable_content', :locals => {:displayable => object}
    
    render :juggernaut do |page|
      page.insert_html :top, 'game', element
      page.draggable object.css_id, :revert => 'drag_revert', :onStart => 'drag_start'
    end
    
    render :nothing => true
  end
end
