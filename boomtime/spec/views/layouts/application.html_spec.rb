require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.haml" do
  before :each do
    @controller.template.stub!(:juggernaut).and_return('')
    @controller.template.stub!(:form_authenticity_token).and_return('')
  end
  
  it "should render application layout" do
    render "/layouts/application"
  end
end

