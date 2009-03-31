module ImagesHelper
  def image_for(object)
    image_tag "/production/images/#{object.image_file_name || 'default.png'}", :alt => object
  end
end
