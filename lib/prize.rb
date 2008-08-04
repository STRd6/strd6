class Prize
  include Item
  
  @@imgs = nil
  
  def initialize
    Prize.image
    
    gem = @@choice.random
    @image = @@imgs[gem]
    @value = @@values[gem]
  end
  
  def self.image
    return if @@imgs
    @@choice = [0,0,0,0,0,1,1,1,2,2,3]
    @@values = [10, 25, 75, 250]
    @@imgs = %w[goldnugget.png greengem.png bluegem.png redgem.png].map { |g| ImageLoader.instance.load(g) }
    return
  end
end
