require File.dirname(__FILE__) + '/test_helper'

ImageLoader.any_instance.stubs(:load).returns(:image)
ImageLoader.any_instance.stubs(:font).returns(:font)

describe Player do
  before do
    @player = Player.new("Shazbot")
  end
  
  it "should be named a given name" do
    name = "Buck Nasty"
    player = Player.new(name)
    player.name.should == name
  end
  
  it "should start in the starting cell" do
    starting_cell = nil
    @player.location.should == starting_cell
  end
  
end