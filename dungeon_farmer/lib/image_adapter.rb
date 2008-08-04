class ImageAdapter
  include Rubygame::Sprites::Sprite
  
  def self.set_screen(screen)
    @@surface = screen
  end  
  
  @@dir = File.dirname(__FILE__) + '/../images'
  
  def initialize(name)
    @rect = Rubygame::Rect.new(0,0,16,16)
    @image = Rubygame::Surface.load("#{@@dir}/#{name}")
  end
  
  def rect
    @rect
  end
  
  def image
    @image
  end
  
  alias :old_draw :draw
  
  def draw(x=nil, y=nil, z=nil)
    @rect.x = x || @rect.x
    @rect.y = y || @rect.y
    old_draw(@@surface)
  end
end

class FontAdapter
  @@dir = File.dirname(__FILE__) + '/../images'
  @@base_size = 16.0
  
  def self.set_screen(screen)
    @@surface = screen
  end  
  
  def initialize(size)
    @@font ||= Rubygame::SFont.new("#{@@dir}/term16.png")
    @zoom = size/@@base_size
  end
  
  def draw(text, x, y, z)
    @@font.render(text).zoom(@zoom, true).blit(@@surface, [x, y])
  end
end
