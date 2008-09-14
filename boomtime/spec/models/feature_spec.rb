require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feature do
  it "should create a new instance" do
    Factory(:feature)
  end
  
  it "should be in an area" do
    f = Factory(:feature, :area => Factory(:area))
    f.area.should_not be_nil
  end
end
