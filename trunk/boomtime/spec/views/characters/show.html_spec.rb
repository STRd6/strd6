require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/characters/show.html.erb" do
  include CharactersHelper
  
  before(:each) do
    assigns[:character] = @character = Factory(:character)
  end

  it "should render attributes in <p>" do
    render "/characters/show"
  end
end

