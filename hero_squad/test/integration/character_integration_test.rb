
require 'test_helper'

class CharacterIntegrationTest < ActiveSupport::TestCase
  context "on cleric" do
    setup do
      @character = Factory :character_instance
    end

    context "strike ability" do
      setup do
        @ability = Factory :ability, :name => "Strike", 
          :attribute_expressions => {:energy_cost => '3', :damage => 'str/2 + 1.d(6)',}
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
  
    context "ability that has range and area" do
      setup do
        @ability = Factory :ability, :activated => true, :attribute_expressions => {
          :range => '6', :area => '2',
        }
        @character = Factory :character_instance
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
end