require File.dirname(__FILE__) + '/test_helper'

describe Cell do
  before(:each) do
    @cell = Cell.new(0,0)
  end

  it "should be empty to begin with" do
    @cell.contents.should == []
  end
end

