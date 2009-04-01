module ImagesHelper
  def image_for(object)
    image_tag "/production/images/#{object.image_file_name || 'default.png'}", :alt => object, :title => object
  end

  def draw_badge(badge)
    image_tag "/images/badges/#{badge.image_file_name}", :alt => badge, :title => badge
  end
end
