module ImagesHelper
  def image_for(object, title_text=nil)
    image = object.image
    image_tag image_url(image) || "/production/images/default.png",
      :width => (image.width if image),
      :height => (image.height if image),
      :alt => title_text || object,
      :title => title_text || object
  end

  def image_submit_tag_for(object, title_text=nil)
    image = object.image
    image_submit_tag image_url(image) || "/production/images/default.png",
      :width => (image.width if image),
      :height => (image.height if image),
      :alt => title_text || object,
      :title => title_text || object
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

  def image_tag_links
    Image.tag_counts_on(:tags).map do |tag|
      link_to("#{tag.name} (#{tag.count})", :tag => tag.name) + " "
    end
  end

  protected

  def image_url(image)
    if image
      "/production/images/#{image.file_name}"
    else
      nil
    end
  end
end
