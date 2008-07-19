require 'singleton'

class ImageLoader
  include Singleton
  
  def load(name, hard_borders=false)
    Gosu::Image.new(@window, "images/#{name}", hard_borders)
  end
  
  def load_a(name, hard_borders=false)
    Gosu::Image.new(@window, name, hard_borders)
  end
  
  def set_window(window)
    @window = window
  end
end
