module Graphical
  attr_reader :image
  
  def il(item)
    return ImageLoader.instance.load(item)
  end
  
  def draw(x=nil, y=nil)
    image.draw(x||@x, y||@y, 0)
  end
end
