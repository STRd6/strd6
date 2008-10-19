require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Character do
  it "should create a new instance" do
    Factory(:character)
  end
  
  it "should have some stats" do
    c = Factory(:character)
    
    c.stats[:str].should_not be_nil
    c.stats[:dex].should_not be_nil
  end
  
  it "should be able to choose a faction" do
    c = Factory(:character)
    c.faction = Factory(:faction)
    c.save.should == true
  end
  
  it "should have an inventory" do
    c = Factory(:character)
    assert c.inventory, "Inventory is nullarino"
  end
  
  it "should have equipped items" do
    
  end
  
  it "should be in an area" do
    c = Factory(:character, :area => Factory(:area))
    c.area.should_not be_nil
    assert c.area.characters.include?(c)
  end
  
  it "should be able to gather resources" do
    
  end
  
  it "should have energy" do
    c = Factory(:character)
    c.energy.should_not be_nil
  end
  
  it "should have overlay text" do
    c = Factory(:character)
    assert c.overlay_text, "No overlay text!"
  end
end
