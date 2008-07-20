class Cell
  attr_reader :x, :y
  attr_accessor :north, :south, :east, :west, :contents, :selected
  @@image = nil
  
  def initialize(x, y)
    @contents = []
    @image = Cell.image
    @x = x
    @y = y
  end
  
  def update
    @contents.each { |c| c.update }
  end
  
  def blocked?
    @contents.any? { |c| c.obstructs? }
  end
  
  def draw
    image.draw(x_pos, y_pos, 0)
    @contents.each {|e| e.draw(x_pos, y_pos)}
  end
  
  def image
    return @@selected if selected
    @@image
  end
  
  def x_pos
    @x*16
  end
  
  def y_pos
    @y*16
  end
  
  def <<(c)
    @contents << c
  end
  
  def delete(c)
    @contents.delete(c)
  end
  
  def self.image
    return @@image if @@image
    @@selected = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'yellow'))
    @@image = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'brown'))
    return @@image
  end
end
