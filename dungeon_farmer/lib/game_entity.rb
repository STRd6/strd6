class GameEntity
  include Graphical, Observable
  
  attr_reader :cell
  attr_accessor :area
  
  def initialize(img=nil, options={})
    instance_options! options
    @image = il img if img
    @listeners = {}
    
    @cell = nil
    @area = nil
    @age = 0
  end
  
  def debug
    "#{to_s}\n"
  end
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
  end
  
  def update
    @age += 1
  end
  
  def obstructs?
    false
  end
  
  def remove
    
  end
  
  def can_pick_up?
    false
  end
  
  def scary?
    false
  end
  
  def instance_options!(options)
    options.each do |sym, value|
      instance_variable_set "@#{sym}", value
    end
  end
end
