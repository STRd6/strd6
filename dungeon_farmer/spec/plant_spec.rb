require File.dirname(__FILE__) + '/test_helper'

describe Plant do
  before(:each) do
    @plant = Plant.new
  end

  it "should begin at age zero" do
    @plant.age.should == 0
  end
  
  it "should be living to begin with" do
    @plant.should_not be_dead
  end
  
  it "should be immature to begin with" do
    @plant.should_not be_mature
  end
  
  it "should age with time" do
    first = @plant.age
    @plant.update
    @plant.age.should > first
  end
  
  it "should require water to survive" do
    
  end
  
  it "should mature after a time" do
    a_time = 100
    
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

