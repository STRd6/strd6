require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  context "a character" do
    setup do
      @character = Factory(:character)
    end
    
    should "have a name" do
      assert @character.name
    end
    
    should "have hit points" do
      assert @character.hit_points
    end
    
    should "have energy" do
      assert @character.energy
    end
    
    should "have actions" do
      assert @character.actions
    end
    
    should "have stats" do
      assert @character.stats
    end
    
    should "have base stats" do
      assert @character.base_stats
    end
    
    should "have abilities" do
      assert @character.abilities
    end
    
    context "with two items" do    
      should "have a primary item" do
        assert @character.primary_item
      end

      should "have a secondary item" do
        assert @character.secondary_item
      end

      should "not have the same item card in primary and secondary slot" do
        assert @character.primary_item != @character.secondary_item
      end
    end
    
    context "that is dead" do
      setup do
        @character = Factory :character, :hit_points => 0
      end
      
      should "have 0 or fewer hit points" do
        assert @character.hit_points <= 0
      end
      
      should "be dead" do
        assert @character.dead?
      end
    end
    
    context "that is alive" do
      should "have 1 or more hit points" do
        assert @character.hit_points >= 1
      end
      
      should "not be dead" do
        assert !@character.dead?
      end
    end
    
    should "be spent or not" do
      assert @character.spent? || !@character.spent?
    end
  end
end
