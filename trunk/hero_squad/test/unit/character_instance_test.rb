require 'test_helper'

class CharacterInstanceTest < ActiveSupport::TestCase
  context "a character instance" do
    setup do
      @character = Factory :character_instance
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
    
    should "have stats methods" do      
      # Basic Stats
      assert @character.str > 0
      assert @character.dex > 0
      assert @character.pow > 0
      assert @character.move >= 0
      assert @character.hp_max > 0
      assert @character.en_max > 0
      
      # Fancy Stats
      assert @character.regen
      assert @character.egen
      assert @character.damage_received
    end
    
    should "have a position in two dimensions" do
      assert_equal 2, @character.position.size
    end
    
    should "be able to set position" do
      @character.position = [1,1]
      
      assert_equal [1,1], @character.position
    end
    
    should "have base stats" do
      assert base_stats = @character.base_stats
      
      assert base_stats[:str]
      assert base_stats[:dex]
      assert base_stats[:pow]
    end
    
    should "have str after reloading" do
      x = @character.str
      @character.reload
      assert_equal x, @character.str
    end
    
    should "have activated abilities" do
      assert @character.activated_abilities
    end
    
    context "with two items" do    
      setup do
        @p_item_card = Factory :card, :data => Factory(:item)
        @s_item_card = Factory :card, :data => Factory(:item, :secondary => true)
        @character = Factory :character_instance, 
          :primary_item_card => @p_item_card, 
          :secondary_item_card => @s_item_card
      end
      
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
    
    context "with an item that modifies stats" do
      setup do
        @item_card = Factory :card, :data => Factory(:item, :stat_mods => {:str => 2})
        @character = Factory :character_instance, :primary_item_card => @item_card
      end
      
      should "have an item" do
        assert @character.primary_item || @character.secondary_item
      end
      
      should "have stats modified by the item" do
        assert_equal @character.base_stats[:str] + @item_card.stat_mods[:str], @character.str
      end
    end
    
    context "with an activated ability" do
      setup do
        card = Factory :card, :data => Factory(:ability)
        @ability = card.data
        @character.assign_card(card, Slot::ABILITY_1)
      end
      
      should "have the assigned activated ability" do
        assert @character.activated_abilities.include?(@ability)
      end
    end
    
    context "with an activated ability granted by an item" do
      setup do
        card = Factory :card, :data => Factory(:item, :base_uses => 3)
        @ability = card.data.invoke_action
        @character.assign_card(card, Slot::ITEM_SECONDARY)
      end
      
      should "have the invokable ability granted by the item" do
        assert @character.activated_abilities.include?(@ability)
      end
    end
    
    context "that is dead" do
      setup do
        @character = Factory :character_instance, :hit_points => 0
      end
      
      should "have 0 or fewer hit points" do
        assert @character.hit_points <= 0
      end
      
      should "be dead" do
        assert @character.dead?
      end
      
      should "be spent" do
        assert @character.spent?
      end
    end
    
    context "that is alive" do
      should "have 1 or more hit points" do
        assert @character.hit_points >= 1
      end
      
      should "not be dead" do
        assert !@character.dead?
      end
      
      context "is not spent" do
        should "not be spent" do
          assert !@character.spent?
        end
      end
    end
    
    context "position related" do
      setup do
        @position = [1,1]
        @character.position = @position
        @character.save
      end
      
      should "be able to find by position" do
        assert CharacterInstance.in_target_with_area(@position, 1).include?(@character), "Character should be found in target area"
      end
    end
  end
end
