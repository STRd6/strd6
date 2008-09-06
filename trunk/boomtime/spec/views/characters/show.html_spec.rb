require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/characters/show.html.erb" do
  include CharactersHelper
  
  before(:each) do
    assigns[:character] = @character = stub_model(Character, :stats => {})
  end

  it "should render attributes in <p>" do
    render "/characters/show"
  end
end

