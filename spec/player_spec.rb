require File.dirname(__FILE__) + '/test_helper'

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
  
  it "should be able to pick up seeds" do
    @player.should be_able_to_pick_up(:seeds)
  end
  
  it "should be able to pick up seeds, but choose not to" do
    @player.should be_able_to_pick_up(:seeds)
    @player.should_not have_item(:seeds)
  end
  
  it "should have things it picked up" do
    @player.pick_up(:seeds)
    @player.pick_up(:fruit)
    @player.should have_item(:seeds)
    @player.should have_item(:fruit)
  end
  
  it "should not have things it didn't pick up" do
    @player.should_not have_item(:seeds)
  end
end