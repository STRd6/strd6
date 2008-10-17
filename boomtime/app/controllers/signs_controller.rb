class SignsController < ResourceController::Base
  before_filter :login_required
  
  create.before do
    object.creator = active_character
    object.area = active_character.area if active_character
  end
  
  create.wants.js do
    element = render_to_string :partial => 'game/displayable_content', :locals => {:displayable => object}
    
    render :juggernaut do |page|
      page.insert_html :top, 'game', element
      page.draggable object.css_id, :revert => 'drag_revert', :onStart => 'drag_start'
      page.call "new Sign", object.css_id
    end
    
    render :nothing => true
  end
end
