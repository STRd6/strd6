require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do

  #Delete this example and add some real ones
  it "should use WelcomeController" do
    controller.should be_an_instance_of(WelcomeController)
  end
  
  describe "requires login" do
    before(:each) do
      controller.stub!(:current_user).and_return(Factory(:user, :active_character => Factory(:character)))
    end
    
    describe "GET 'index'" do
      it "should send chat messages" do
        post 'send_data', :chat_input => 'hiya!'
        response.should be_success
      end
    end
  end

end
