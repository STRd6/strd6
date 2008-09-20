class Prize
  
  @@imgs = nil
  
  def self.generate
    image
    gem = @@choice.random
    Item.new(@@imgs[gem], :value => @@values[gem])
  end
  
  def self.image
    return if @@imgs
    @@choice = [0,0,0,0,0,1,1,1,2,2,3]
    @@values = [10, 25, 75, 250]
    @@imgs = %w[goldnugget greengem bluegem redgem].map { |g| "items/#{g}.png" }
    return
  end
  
private
  def initialize

  end
end
