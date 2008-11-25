require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GameController do

  #Delete these examples and add some real ones
  it "should use GameController" do
    controller.should be_an_instance_of(GameController)
  end

  describe "requires login" do
    before(:each) do
      controller.stub!(:current_user).and_return(Factory(:user, :active_character => Factory(:character)))
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end
    
    describe "GET 'get_displayable'" do
      describe "when valid" do
        before(:each) do
          Item.should_receive(:find).with("37").and_return(Factory(:item))
        end
        
        it "should return the displayable data" do
          get 'get_displayable', :id => "37", :class => 'Item'
          response.should be_success
        end
      end
      
      it "should return 403 when invalid" do
        get 'get_displayable', :id => "37", :class => 'ApplicationController'
        response.should_not be_success
      end
    end
  end
  
  describe "requires active character" do
    before(:each) do
      controller.stub!(:current_user).and_return(Factory(:user))
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_redirect
      end
    end
  end
#
#  describe "GET 'feature_move'" do
#    it "should be successful" do
#      get 'feature_move'
#      response.should be_success
#    end
#  end
end
