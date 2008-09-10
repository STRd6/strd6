require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Faction do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Faction.create!(@valid_attributes)
  end
  
  it "should have many characters" do
    f = Faction.create!(@valid_attributes)
    f.characters.should_not be_nil    
  end
end
