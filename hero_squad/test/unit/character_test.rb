require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  context "a character" do
    setup do
      @character = Factory(:character)
    end
    
    should "have a primary item" do
      assert @character.primary_item
    end
    
    should "have a secondary item" do
      assert @character.secondary_item
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
    
    should "have hit points" do
      assert @character.hit_points
    end
    
    should "have energy" do
      assert @character.energy
    end
    
    should "have actions" do
      assert @character.actions
    end
    
    should "be spent or not" do
      assert @character.spent? || !@character.spent?
    end
    
    should "be dead or not" do
      assert @character.dead? || !@character.dead?
    end
  end
end
