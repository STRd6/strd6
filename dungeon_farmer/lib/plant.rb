class Plant
  include Graphical
  attr_reader :age
  
  def initialize
    @age = 0
    @@images ||= ['seed.png', 'sprout.png', 'plant1.png', 'plant2.png', 'plant3.png'].map do
      |file| il(file)
    end
  end
    
  def update
    @age += 1
  end
  
  def mature?
    age > 99
  end
  
  def obstructs?
    return mature?
  end
  
  def dead?
    age > 749
  end
  
  def image
    @@images[@age/50] || @@images.last
  end
  
  def can_pick_up?
    false
  end
end
