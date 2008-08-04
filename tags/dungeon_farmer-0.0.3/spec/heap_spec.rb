require File.dirname(__FILE__) + '/test_helper'

describe Heap do
  before(:each) do
    @heap = Heap.new
  end

  it "should be empty when new" do
    @heap.should be_empty
  end
  
  it "should have size equal to the number of items added" do
    @heap.push(1,2,3,4,5)
    @heap.size.should == 5
  end
  
  it "should pop the least" do
    @heap.push(5,4,3,2,1)
    @heap.pop.should == 1
    @heap.pop.should == 2
    @heap.pop.should == 3
    @heap.pop.should == 4
    @heap.pop.should == 5
    
    @heap.push(3,4,5,1,2)
    @heap.pop.should == 1
    @heap.pop.should == 2
    @heap.pop.should == 3
    @heap.pop.should == 4
    @heap.pop.should == 5
    
    @heap.should be_empty
  end
end

