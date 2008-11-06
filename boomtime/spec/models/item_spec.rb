require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  it "should create a new instance" do
    Factory(:item)
  end
  
  it "should have properties" do
    item = Factory(:item)
    assert item.properties
  end
  
  it "should be prototypeable" do
    item = Factory(:item, :prototype => :axe, :creator => Factory(:character))
    
    assert_equal :axe, item.properties[:prototype]
  end
end
