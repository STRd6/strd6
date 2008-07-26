class Cell
  attr_reader :x, :y
  attr_accessor :north, :south, :east, :west, :contents, :selected
  @@land = nil
  
  def initialize(x, y, h=0.5)
    Cell.image
    
    @contents = []
    @x = x
    @y = y
    @height = h
    
    if @height < 0.0
      @blocked = true
      @image = @@water
    elsif @height < 0.4
      @blocked = false
      @image = @@land
    else
      @blocked = true
      @image = @@mountain
    end
  end
  
  def update
    @contents.each { |c| c.update }
  end
  
  def dig
    @blocked = false
    @image = @@land
  end
  
  def blocked?
    @blocked
  end
  
  def has_resource?
    @contents.any? {|c| c.can_pick_up? }
  end
  
  def draw
    image.draw(x_pos, y_pos, 0)
    @contents.each {|e| e.draw(x_pos, y_pos)}
  end
  
  def image
    return @@selected if selected
    @image
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
  
  def to_s
    "[#{x}, #{y}]"
  end
  
  def self.image
    return @@land if @@land
    @@selected = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'yellow'))
    @@water = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'blue'))
    @@land = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'brown'))
    @@mountain = ImageLoader.instance.load_a(ImageMaker.blank(16, 16, 'gray'))
    return @@land
  end
end
