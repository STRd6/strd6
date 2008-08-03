require 'singleton'

class ImageLoader
  include Singleton
  
  @@dir = File.dirname(__FILE__) + '/../images'
  
  def load(name, hard_borders=false)
    Gosu::Image.new(@window, "#{@@dir}/#{name}", hard_borders)
  end
  
  def load_a(name, hard_borders=false)
    Gosu::Image.new(@window, name, hard_borders)
  end
  
  def font
    Gosu::Font.new(@window, Gosu::default_font_name, 12)
  end
  
  def set_window(window)
    @window = window
  end
end
