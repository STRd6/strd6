require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Area do
  it "should create a new instance" do
    Factory(:area)
  end
  
  it "should know what areas it is connected to" do
    area = Factory(:area)
    area.adjacent_areas.should_not be_nil
  end
  
  it "should have terrain features" do
    
  end
  
  it "should be able to be blocked by building a wall" do
    
  end
  
  it "should be able to contain a house built by players" do
    
  end
  
  it "should be able to contain plants" do
    
  end
end
