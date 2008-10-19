require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AreasController do

  #Delete this example and add some real ones
  it "should use AreasController" do
    controller.should be_an_instance_of(AreasController)
  end
  
  describe "responding to GET index" do
    it "should expose all areas as @areas" do      
      get :index
      assert assigns[:areas], "Failed to assign areas"
    end
  end

end
