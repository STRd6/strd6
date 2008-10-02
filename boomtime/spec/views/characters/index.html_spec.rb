require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/characters/index.html.erb" do
  include CharactersHelper
  
  before(:each) do
    assigns[:characters] = [
      Factory(:character),
      Factory(:character)
    ]
  end

  it "should render list of characters" do
    render "/characters/index"
  end
end

