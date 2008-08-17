require File.dirname(__FILE__) + '/test_helper'

ImageLoader.any_instance.stubs(:load).returns(:image)
Area.any_instance.stubs(:remove_entity).returns(true)

describe Plant do
  before(:each) do
    cell = Cell.new(0,0)
    cell.north = cell.south = cell.east = cell.west = cell
    @plant = Plant.new(cell)
  end

  it "should be living to begin with" do
    @plant.should_not be_dead
  end
  
  it "should be immature to begin with" do
    @plant.should_not be_mature
  end
  
  it "should require water to survive" do
    
  end
  
  it "should mature after a time" do
    a_time = 200
    
    a_time.times do
      @plant.update
    end
    
    @plant.should be_mature
  end
  
  it "should produce seeds when mature" do

  end
  
  it "should die after a long time" do
    a_long_time = 1000
    
    a_long_time.times do
      @plant.update
    end
    
    @plant.should be_dead
  end
end

