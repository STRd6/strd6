require 'singleton'

class ImageLoader
  include Singleton
  
  def load(name, hard_borders=false)
    return @cache[name] if @cache[name]
    
    if $RUBYGAME
      @cache[name] = ImageAdapter.new(name)
    else
      @cache[name] = Gosu::Image.new(@window, "#{@dir}/#{name}", hard_borders)
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
    @cache = {}
    @dir = File.dirname(__FILE__) + '/../images'
  end
end
