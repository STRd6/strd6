require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Area do
  it "should create a new instance" do
    Factory(:area)
  end
  
  it "should know what areas it is connected to" do
    area = Factory(:area)
    area.adjacent_areas.should == []
  end
  
  it "should contain characters" do
    area = Factory(:area, :characters => [Factory(:character), Factory(:character)])
    assert_equal 2, area.characters.size
    area.characters.each do |c|
      assert c.area == area
    end
  end
  
  it "should have terrain features" do
    area = Factory(:area)
    area.features.should == []
  end
  
  it "should be able to be blocked by building a wall" do
    
  end
  
  it "should be able to contain a house built by players" do
    
  end
  
  it "should be able to contain plants" do
    
  end
end
