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
    
    context "strike ability" do
      setup do
        @ability = Factory :ability, :name => "Strike", 
          :attribute_expressions => {:energy_cost => '3', :damage => 'str/2 + 1.d(6)',}
      end
      
      context "on cleric" do
        setup do
          @character = Factory :character_instance
        end
        
        should "have damage between 3 and 8" do
          min = 100
          max = 0
          
          assert_equal 5, @character.str
          
          100.times do
            roll = @ability.damage(@character)
            min = roll if roll < min
            max = roll if roll > max
          end
          
          assert_equal 3, min
          assert_equal 8, max
        end
      end
    end
    
    context "which is activated" do
      setup do
        @ability = Factory :ability, :activated => true
        @character = Factory :character_instance
      end
      
      should "be activated" do
        assert @ability.activated?
      end
      
      should "have action attributes that are evaluated on a character" do
        assert @ability.energy_cost(@character)
        assert @ability.life_loss(@character)
        assert @ability.range(@character)
        assert @ability.area(@character)
        assert @ability.damage(@character)
        assert @ability.energy_damage(@character)
        assert @ability.heal(@character)
        assert @ability.energy_gain(@character)
        assert @ability.duration(@character)
        assert @ability.actions_required(@character)
      end
      
      should "have a target type" do
        assert @ability.target_type
      end
      
      context "has range and area" do
        setup do
          @ability = Factory :ability, :activated => true, :attribute_expressions => {
            :range => '6', :area => '2',
          }
        end
        
        should "have action attributes that are evaluated on a character" do
          assert @ability.energy_cost(@character)
          assert @ability.life_loss(@character)
          assert @ability.range(@character)
          assert @ability.area(@character)
          assert @ability.damage(@character)
          assert @ability.energy_damage(@character)
          assert @ability.heal(@character)
          assert @ability.energy_gain(@character)
          assert @ability.duration(@character)
          assert @ability.actions_required(@character)
        end
      end
    end
    
    context "which is passive" do
      should "be passive" do
        assert @ability.passive?
      end
    end
  end
end
