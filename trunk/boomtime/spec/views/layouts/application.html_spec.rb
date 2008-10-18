require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.haml" do
  before :each do
    @controller.template.stub!(:juggernaut).and_return('')
    @controller.template.stub!(:form_authenticity_token).and_return('')
  end
  
  it "should render application layout" do
    render "/layouts/application"
  end
  
  describe "while logged in" do
    before(:each) do
       @controller.template.stub!(:current_user).and_return(Factory(:user))
    end

    it "should render application layout" do
      render "/layouts/application"
    end

    describe "with an active character" do
      before(:each) do
         @controller.template.stub!(:active_character).and_return(Factory(:character))
      end

      it "should render application layout" do
        render "/layouts/application"
      end
    end
  end
end

