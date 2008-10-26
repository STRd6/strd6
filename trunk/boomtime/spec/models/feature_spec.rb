require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feature do
  it "should create a new instance" do
    Factory(:feature)
  end
  
  it "should not create a new instance without creator" do
    feature = Factory.build(:feature, :creator => nil)
    assert_equal false, feature.save
  end  
  
  it "should be in an area" do
    f = Factory(:feature, :area => Factory(:area))
    f.area.should_not be_nil
  end
  
  it "should have properties" do
    f = Factory(:feature)
    f.properties.should_not be_nil
  end
end
