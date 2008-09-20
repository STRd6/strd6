class Cell
  include Graphical
  
  attr_reader :x, :y
  attr_accessor :north, :south, :east, :west, :contents, :to_dig, :zone
  
  @@water = ['water1.png']
  @@land = %w[ground1 ground2 ground3].map { |g| "#{g}.png" }
  @@mountain = %w[mountain1 mountain2 mountain3].map { |g| "#{g}.png" }
  
  def initialize(x, y, h=0.5)
    @contents = []
    @x = x
    @y = y
    @height = h
    
    if @height < 0.25
      @blocked = true
      img = @@water.random
    elsif @height < 0.75
      @blocked = false
      img = @@land.random
    else
      @blocked = true
      img = @@mountain.random
    end
    
    @image = il img
  end
  
  def debug
    s = "#{to_s} \n"
    
    @contents.each do |c|
      s << c.debug
    end
    
    return s
  end
  
  def update
    @contents.each { |c| c.update }
  end
  
  def dig
    @to_dig = false
    @blocked = false
    @image = il @@land.random
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
  
  def flood
    @image = il @@water.random
    @blocked = true
  end
  
  def image
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
  
  def neighbours
    return @neighbours ||= [north, east, south, west]
  end
end
