# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def p_label(label, data)
    "<p>#{label_tag label} #{data}</p>"
  end
  
  def end_drag
    'function(element, mouse_event) { end_drag(element, mouse_event); }'
  end
  
  def hash_for_draggable(id)
    on_end = current_user ? "function() { end_drag($('#{id}')); }" : 'false'
    
    {:snap => '[10,10]', 
     :onEnd => on_end, 
     :handle => "'#{id}_handel'"}
  end
  
  def window_style(id)
    return "" unless current_user
    
    w = WindowPosition.first :conditions => {:user_id => current_user.id, :window => id}

    return "" unless w
    
    "top: #{w.top}px; left: #{w.left}px;"
  end
  
end
