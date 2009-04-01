module ImagesHelper
  def image_for(object)
    image_tag "/production/images/#{object.image_file_name || 'default.png'}", :alt => object, :title => object
  end

  def draw_badge(badge)
    image_tag "/images/badges/#{badge.image_file_name}", :alt => badge, :title => badge
  end

  def image_select(form)
    Image.all.map do |image|
      form.label("image_id_#{image.id}", image_for(image) ) +
      form.radio_button(:image_id, image.id)
    end
  end
end
