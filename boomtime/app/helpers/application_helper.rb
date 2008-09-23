# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def p_label(label, data)
    "<p>#{label_tag label} #{data}</p>"
  end
  
  def end_drag
    'function(element, mouse_event) { end_drag(element, mouse_event); }'
  end
end
