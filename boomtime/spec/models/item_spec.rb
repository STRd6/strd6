require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  it "should create a new instance" do
    Factory(:item)
  end
end
