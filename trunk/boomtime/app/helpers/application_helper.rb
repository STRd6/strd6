# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def p_label(label, data)
    "<p>#{label_tag label} #{data}</p>"
  end
  
  def window(id)
    {:layout => 'components/window', :locals => {:name => id}}
  end
  
  def on_click(id, js)
    
  end
end
