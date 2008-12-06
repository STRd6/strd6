require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  context "on CREATE" do
    setup do
      Factory :player
      Factory :player
      
      post :create, :players => [1,2], :name => 'Cool game name'
    end
    
    should_respond_with :redirect
  end
  
  context "on INDEX" do
    setup do
      ActionView::Base.any_instance.stubs(:juggernaut)
      Factory :game
      
      get :index
    end
    
    should_respond_with :success
  end
  
  context "on SHOW" do
    setup do
      ActionView::Base.any_instance.stubs(:juggernaut)
      g = Factory :game
      
      get :show, :id => g.id
    end
    
    should_respond_with :success
    should_assign_to :game
  end
  
  context "on NEW" do
    setup do
      ActionView::Base.any_instance.stubs(:juggernaut)
      get :new
    end
    
    should_respond_with :success
    should_assign_to :game
    should_render_a_form
  end
end
