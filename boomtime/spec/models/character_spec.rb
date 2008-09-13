require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Character do
  before(:each) do
    @valid_attributes = {
      :name => "World's Greatest Name!"
    }
  end

  it "should create a new instance given valid attributes" do
    Character.create!(@valid_attributes)
  end
  
  it "should have some stats" do
    c = Character.create(@valid_attributes)
    
    c.stats[:str].should_not be_nil
    c.stats[:dex].should_not be_nil
  end
  
  it "should be able to choose a faction" do
    c = Character.new(@valid_attributes)
    c.faction = Faction.new
    c.save.should == true
  end
  
  it "should have an inventory" do
    
  end
  
  it "should have equipped items" do
    
  end
  
  it "should be in an area" do
    
  end
  
  it "should be able to gather resources" do
    
  end
end
