require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "an ability" do
    setup do
      @ability = Factory :ability
    end
    
    should "have a name" do
      assert @ability.name 
    end
    
    should "have stat mods" do
      assert @ability.stat_mods
    end
    
    context "which is activated" do
      setup do
        @ability = Factory :ability, :activated => true
      end
      
      should "be activated" do
        assert @ability.activated?
      end
      
      should "have a target type" do
        assert @ability.target_type
      end
    end
    
    context "which is passive" do
      setup do
        @ability = Factory :ability, :activated => false
      end
      
      should "be passive" do
        assert @ability.passive?
      end
    end
    
    should "maintain attribute expressions across reloads" do
      @ability.attribute_expressions[:energy_cost] = "3"
      @ability.save
      @ability.reload
      assert_equal "3", @ability.attribute_expressions[:energy_cost]
    end
    
    should "maintain stat mods across reloads" do
      @ability.stat_mods[:pow] = 3
      @ability.save
      @ability.reload
      assert_equal 3, @ability.stat_mods[:pow]
    end
  end
end
