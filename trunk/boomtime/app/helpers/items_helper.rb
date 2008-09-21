module ItemsHelper
  def item_image(img)
    image_tag "items/#{img}.png", :class => 'item'
  end
end
