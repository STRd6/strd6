require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CharactersController do
  
  def mock_character(stubs={})
    @mock_character ||= mock_model(Character, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  before(:each) do
    controller.stub!(:current_user).and_return(mock_user)
  end
  
  describe "responding to GET index" do

    it "should expose all characters as @characters" do
      mock_user.should_receive(:characters).and_return([mock_character])
      
      get :index
      assigns[:characters].should == [mock_character]
    end

#    describe "with mime type of xml" do
#  
#      it "should render all characters as xml" do
#        request.env["HTTP_ACCEPT"] = "application/xml"
#        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
#        characters.should_receive(:to_xml).and_return("generated XML")
#        
#        get :index
#        response.body.should == "generated XML"
#      end
#    
#    end

  end

  describe "responding to GET show" do

    it "should expose the requested character as @character" do
      mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
      characters.should_receive(:find).with("37").and_return(mock_character)
      
      get :show, :id => "37"
      assigns[:character].should equal(mock_character)
    end
    
#    describe "with mime type of xml" do
#
#      it "should render the requested character as xml" do
#        request.env["HTTP_ACCEPT"] = "application/xml"
#        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
#        characters.should_receive(:find).with("37").and_return(mock_character)        
#        mock_character.should_receive(:to_xml).and_return("generated XML")
#        
#        get :show, :id => "37"
#        response.body.should == "generated XML"
#      end
#
#    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new character as @character" do
      mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
      characters.should_receive(:new).and_return(mock_character)
      
      get :new
      assigns[:character].should equal(mock_character)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested character as @character" do
      mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
      characters.should_receive(:find).with("37").and_return(mock_character)
      
      get :edit, :id => "37"
      assigns[:character].should equal(mock_character)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created character as @character" do
        valid_params = {'name' => 'A Good Name'}
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.should_receive(:new).with(valid_params).and_return(mock_character(:save => true))
        
        post :create, :character => valid_params
        assigns(:character).should equal(mock_character)
      end

      it "should redirect to the created character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:new).and_return(mock_character(:save => true))
        
        post :create, :character => {}
        response.should redirect_to(character_url(mock_character))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved character as @character" do
        invalid_params = {'no' => 'name'}
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:new).with(invalid_params).and_return(mock_character(:save => false))
        
        post :create, :character => invalid_params
        assigns(:character).should equal(mock_character)
      end

      it "should re-render the 'new' template" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:new).and_return(mock_character(:save => false))
        
        post :create, :character => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.should_receive(:find).with("37").and_return(mock_character)
        mock_character.should_receive(:update_attributes).with({'these' => 'params'})
        
        put :update, :id => "37", :character => {:these => 'params'}
      end

      it "should expose the requested character as @character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:find).and_return(mock_character(:update_attributes => true))
        
        put :update, :id => "1"
        assigns(:character).should equal(mock_character)
      end

      it "should redirect to the character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:find).and_return(mock_character(:update_attributes => true))
        
        put :update, :id => "1"
        response.should redirect_to(character_url(mock_character))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.should_receive(:find).with("37").and_return(mock_character)
        mock_character.should_receive(:update_attributes).with({'these' => 'params'})
        
        put :update, :id => "37", :character => {:these => 'params'}
      end

      it "should expose the character as @character" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:find).and_return(mock_character(:update_attributes => false))
        
        put :update, :id => "1"
        assigns(:character).should equal(mock_character)
      end

      it "should re-render the 'edit' template" do
        mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
        characters.stub!(:find).and_return(mock_character(:update_attributes => false))
        
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested character" do
      mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
      characters.should_receive(:find).with("37").and_return(mock_character)
      mock_character.should_receive(:destroy).and_return(true)
      
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the characters list" do
      mock_user.should_receive(:characters).and_return(characters = mock("Array of Characters"))
      characters.stub!(:find).and_return(mock_character(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(characters_url)
    end

  end
  
  describe "responding to activate_character" do
    it "should activate the given character if the current user owns the character" do
      user = Factory(:user, :characters => [Factory(:character)], :active_character => nil)
      
      controller.stub!(:current_user).and_return user
      
      get :activate, :id => user.characters.first.id
      response.should redirect_to(characters_url)

      # The character should be activated
      user.reload
      user.active_character.should == user.characters.first
    end
    
    it "should not activate the given character if the current user does not own the character" do
      user = Factory(:user, :characters => [Factory(:character)], :active_character => nil)
      
      controller.stub!(:current_user).and_return user
      
      previously_active_character = user.active_character
      
      get :activate, :id => 0
      response.should redirect_to(characters_url)
      
      #The previously active character should remain
      user.reload
      user.active_character.should == previously_active_character
    end
    
  end

end
