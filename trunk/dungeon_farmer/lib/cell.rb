class Cell
  attr_reader :x, :y
  attr_accessor :north, :south, :east, :west, :contents, :to_dig, :seeds, :zone
  
  @@land = nil
  
  def initialize(x, y, h=0.5)
    Cell.image
    
    @contents = []
    @x = x
    @y = y
    @height = h
    @seeds = 0
    
    if @height < 0.2
      @blocked = true
      @image = @@water
    elsif @height < 0.7
      @blocked = false
      @image = @@land.random
    else
      @blocked = true
      @image = @@mountain.random
    end
  end
  
  def debug
    s = "#{to_s} #{@seeds} seeds\n"
    
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
    @image = @@land.random
  end
  
  def blocked?
    @blocked
  end
  
  def has_resource?
    @seeds > 0 || @contents.any? {|c| c.can_pick_up? }
  end
  
  def draw
    image.draw(x_pos, y_pos, 0)
    @contents.each {|e| e.draw(x_pos, y_pos)}
    @@seed.draw(x_pos, y_pos, 0) if @seeds > 0
  end
  
  def flood
    @image = @@water
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
  
  def self.image
    return if @@land
    @@seed = ImageLoader.instance.load('seed.png')
    @@water = ImageLoader.instance.load('water1.png')
    @@land = %w[ground1 ground2 ground3].map { |g| ImageLoader.instance.load("#{g}.png") }
    @@mountain = %w[mountain1 mountain2 mountain3].map { |g| ImageLoader.instance.load("#{g}.png") }
  end
end
