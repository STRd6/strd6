require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/characters/index.html.erb" do
  include CharactersHelper
  
  before(:each) do
    assigns[:characters] = [
      stub_model(Character, :stats => {}),
      stub_model(Character, :stats => {})
    ]
  end

  it "should render list of characters" do
    render "/characters/index"
  end
end

