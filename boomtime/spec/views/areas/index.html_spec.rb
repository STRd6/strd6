require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/areas/index.html.haml" do
  #include CharactersHelper
  
  before(:each) do
    assigns[:areas] = [
      Factory(:area),
      Factory(:area)
    ]
  end

  it "should render list of areas" do
    render "/areas/index"
  end
end

