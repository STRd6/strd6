module ImagesHelper
  def image_for(object)
    if (image = object.image)
      image_tag "/production/images/#{image.file_name}",
        :width => image.width,
        :height => image.height,
        :alt => object,
        :title => object
    else
      image_tag "/production/images/default.png",
        :width => 32,
        :height => 32,
        :alt => object,
        :title => object
    end
  end

  def draw_badge(badge)
    image_tag "/images/badges/#{badge.image_file_name}", :alt => badge, :title => badge
  end

  def image_select(form, size=:small)
    Image.send(size).all.map do |image|
      form.label("image_id_#{image.id}", image_for(image) ) +
      form.radio_button(:image_id, image.id)
    end
  end
end
