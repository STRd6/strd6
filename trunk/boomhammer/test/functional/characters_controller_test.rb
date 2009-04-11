require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  context "characters" do
    setup do
      CharactersController.any_instance.stubs(:login_required)
    end

    should "GET new" do
      get :new
    end
  end
end
