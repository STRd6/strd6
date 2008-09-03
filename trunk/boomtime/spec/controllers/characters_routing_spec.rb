require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CharactersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "characters", :action => "index").should == "/characters"
    end
  
    it "should map #new" do
      route_for(:controller => "characters", :action => "new").should == "/characters/new"
    end
  
    it "should map #show" do
      route_for(:controller => "characters", :action => "show", :id => 1).should == "/characters/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "characters", :action => "edit", :id => 1).should == "/characters/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "characters", :action => "update", :id => 1).should == "/characters/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "characters", :action => "destroy", :id => 1).should == "/characters/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/characters").should == {:controller => "characters", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/characters/new").should == {:controller => "characters", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/characters").should == {:controller => "characters", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/characters/1").should == {:controller => "characters", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/characters/1/edit").should == {:controller => "characters", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/characters/1").should == {:controller => "characters", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/characters/1").should == {:controller => "characters", :action => "destroy", :id => "1"}
    end
  end
end
