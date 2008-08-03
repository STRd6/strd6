module Graphical
  attr_reader :image
  
  def il(item)
    return ImageLoader.instance.load(item)
  end
  
  def draw(x=nil, y=nil, z=0)
    image.draw(x||@x, y||@y, z)
  end
end
