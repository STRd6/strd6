# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def p_label(label, data)
    "<p>#{label_tag label}: <br/>
     #{data}</p>"
  end
  
end
