require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Faction do
  it "should create a new instance" do
    Factory(:faction)
  end
  
  it "should have many characters" do
    f = Factory(:faction, :characters => [Factory(:character)])
    assert f.characters.size > 0
  end
end
