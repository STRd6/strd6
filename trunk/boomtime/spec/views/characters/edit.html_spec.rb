require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/characters/edit.html.erb" do
  include CharactersHelper
  
  before(:each) do
    assigns[:character] = @character = Factory(:character)
  end

  it "should render edit form" do
    render "/characters/edit"
    
    response.should have_tag("form[action=#{character_path(@character)}][method=post]") do
    end
  end
end


