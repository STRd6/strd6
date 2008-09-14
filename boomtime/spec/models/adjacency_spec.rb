require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Adjacency do
  it "should create a new instance" do
    a = Factory(:adjacency)
    a.area.should_not be_nil
    a.adjacent_area.should_not be_nil
  end
  
  it "should be invalid if area or adjacenct_area is nil" do
    Factory.build(:adjacency, :area => nil).should_not be_valid
    Factory.build(:adjacency, :adjacent_area => nil).should_not be_valid
  end
  
end
