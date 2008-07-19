class Plant
  include Graphical
  attr_reader :age
  
  def initialize
    @age = 0
    @images = ['seed.png', 'sprout.png', 'plant1.png', 'plant2.png', 'plant3.png'].map do
      |item| il(item)
    end
  end
    
  def update
    @age += 1
  end
  
  def mature?
    age > 99
  end
  
  def dead?
    age > 750
  end
  
  def image
    @images[@age/50] || @images.last
  end
end
