require 'test_helper'
class PlayersControllerTest < ActionController::TestCase
  context "Players Controller" do
    setup do
      ActionView::Base.any_instance.stubs(:juggernaut)
    end
    
    context "on CREATE" do
      setup do
        post :create, { :player => {
          :name => 'New Player'
        }}
      end

      should_respond_with :redirect
    end

    context "on INDEX" do
      setup do
        Factory :player

        get :index
      end

      should_respond_with :success
    end

    context "on SHOW" do
      setup do
        player = Factory :player

        get :show, :id => player.id
      end

      should_respond_with :success
      should_assign_to :player
    end

    context "on NEW" do
      setup do
        get :new
      end

      should_respond_with :success
      should_assign_to :player
      should_render_a_form
    end
  end
end