require 'test_helper'

class ItemTest < ActiveSupport::TestCase
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
      
      should "have action attributes" do
        assert @ability.energy_cost
        assert @ability.hit_point_cost
        assert @ability.range
        assert @ability.area
        assert @ability.damage
        assert @ability.energy_damage
        assert @ability.heal
        assert @ability.energy_gain
        assert @ability.duration
      end
      
      should "have a target type" do
        assert @ability.target_type
      end
    end
    
    context "which is passive" do
      should "be passive" do
        assert @ability.passive?
      end
    end
  end
end
