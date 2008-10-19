require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sign do
  before(:each) do
    @valid_attributes = {
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    Sign.create!(@valid_attributes)
  end
  
  it "should have overlay text" do
    assert Factory(:sign).overlay_text, "No overlay text found"
  end
end
