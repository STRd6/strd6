require 'test_helper'

class AbilityIntegrationTest < ActiveSupport::TestCase
  context "an ability being activated by a character instance" do
    setup do
      @ability = Factory :ability
      @character_instance = Factory :character_instance
    end
    
    should "return a result hash" do
      result = @ability.action_hash(@character_instance)
      assert result
      assert result[:energy_cost]
    end
    
    context "against a character in a target location" do
      setup do
        @target_position = [1,1]
        @other_character = Factory :character_instance
        @other_character.position = @target_position
        @other_character.save
      end
      
      should "return a list containing that character" do
        targets = CharacterInstance.in_target_with_area(@target_position, 1)
        assert targets.include?(@other_character), "Targets should include other character."
      end
    end
  end
end