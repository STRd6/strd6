module ItemsHelper
  def item_image(img)
    image_tag "items/#{img}.png", :class => 'item'
  end
  
  def action_image(img)
    image_tag "actions/#{img}.png", :class => 'action'
  end
end
