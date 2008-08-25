class Seed < Item
  def initialize(plant)
    super(plant.seed_img, :plant => plant)
  end
end
