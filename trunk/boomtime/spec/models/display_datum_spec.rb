require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DisplayDatum do
  before(:each) do
    @valid_attributes = {
      :top => "1",
      :left => "1",
      :z => "1",
      :image => "value for image"
    }
  end

  it "should create a new instance given valid attributes" do
    DisplayDatum.create!(@valid_attributes)
  end
end
