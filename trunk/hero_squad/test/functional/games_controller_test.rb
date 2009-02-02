require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  context "Games Controller" do
    setup do
      ActionView::Base.any_instance.stubs(:juggernaut)
    end
    
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
        Factory :game

        get :index
      end

      should_respond_with :success
    end

    context "on SHOW" do
      setup do
        game = Factory :game

        get :show, :id => game.id
      end

      should_respond_with :success
      should_assign_to :game
    end

    context "on NEW" do
      setup do
        get :new
      end

      should_respond_with :success
      should_assign_to :game
      should_render_a_form
    end
    
    context "game commands" do
      setup do
        # Create a test character to derive instances of, one for each player
        Factory :character
        
        # Create the test ability
        @ability = Factory :ability, :name => "Strike"
        
        @game = Game.make("Action Game", [Factory(:player), Factory(:player)])
      end
      
      should "let characters blast each other" do
        post :character_action, { 
          :id => @game.id, 
          :x => 0, :y => 0,
          :character_instance => {
            :id => 1
          },
          :ability_id => 0,
          :ability_name => @ability.name
        }
      end
      
      should "be a teapot when incorrect" do
        post :character_action, { 
          :id => @game.id, 
          :x => 0, :y => 0,
          :character_instance => {
            :id => 1
          },
        }
        
        assert_response 418
      end
    end
  end
end
