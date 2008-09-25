require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WindowPosition do
  before(:each) do
    @valid_attributes = {
      :window => "value for window",
      :top => "1",
      :left => "1",
      :z => "1",
      :user => nil
    }
  end

  it "should create a new instance given valid attributes" do
    WindowPosition.create!(@valid_attributes)
  end
end
