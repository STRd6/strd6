require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sign do
  it "should create a new instance" do
    Factory(:sign)
  end
  
  it "should not create a new instance without creator" do
    sign = Factory.build(:sign, :creator => nil)
    assert_equal false, sign.save
  end  
  
  it "should have overlay text" do
    assert Factory(:sign).overlay_text, "No overlay text found"
  end
end
