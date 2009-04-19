module ImagesHelper
  def image_for(object)
    if (image = object.image)
      image_tag image_url(image),
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

  def image_submit_tag_for(object)
    if (image = object.image)
      image_submit_tag image_url(image),
        :width => image.width,
        :height => image.height,
        :alt => object,
        :title => object
    else
      image_submit_tag "/production/images/default.png",
        :width => 32,
        :height => 32,
        :alt => object,
        :title => object
    end
  end

  def draw_badge(badge)
    image_tag "/images/badges/#{badge.image_file_name}", :alt => badge, :title => badge
  end

  def image_select(form, options={})
    options.reverse_merge! :size => :small

    finder = Image.send(options[:size])

    if options[:tagged]
      finder = finder.tagged_with options[:tagged], :on => :tags
    end

    return finder.all.map do |image|
      form.label("image_id_#{image.id}", image_for(image) ) +
      form.radio_button(:image_id, image.id)
    end
  end

  protected

  def image_url(image)
    "/production/images/#{image.file_name}"
  end
end
