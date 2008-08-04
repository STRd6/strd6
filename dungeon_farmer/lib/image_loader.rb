require 'singleton'

class ImageLoader
  include Singleton
  
  @@dir = File.dirname(__FILE__) + '/../images'
  
  def load(name, hard_borders=false)
    if $RUBYGAME
      ImageAdapter.new(name)
    else
      Gosu::Image.new(@window, "#{@@dir}/#{name}", hard_borders)
    end
  end
  
  def load_a(name, hard_borders=false)
    Gosu::Image.new(@window, name, hard_borders)
  end
  
  def font(size=12)
    if $RUBYGAME
      FontAdapter.new(size)
    else
      Gosu::Font.new(@window, Gosu::default_font_name, size)
    end
  end
  
  def set_window(window)
    @window = window
  end
end
