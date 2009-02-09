require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  context "an item" do
    setup do
      @item = Factory :item, :stat_mods => {:pow => 2}
    end

    should "have stat modifications" do
      assert @item.stat_mods
    end
    
    should "have a name" do
      assert @item.name
    end
    
    should "maintain stat mods across reloads" do
      @item.stat_mods[:pow] = 3
      @item.save
      @item.reload
      assert_equal 3, @item.stat_mods[:pow]
    end
  end
  
  context "a usable item" do
    setup do
      @item = Factory :item, :base_uses => 3
    end
    
    should "be usable" do
      assert @item.usable?
    end
    
    should "have uses" do
      assert @item.uses
    end
    
    should "have an invoke action" do
      assert @item.invoke_action
    end
  end
  
  context "a secondary item" do
    setup do
      @item = Factory :item, :secondary => true
    end
    
    should "be secondary" do
      assert @item.secondary?
    end
  end
  
  context "an unusable item" do
    setup do
      @item = Factory(:item, :base_uses => nil)
    end
    
    should "not be usable" do
      assert !@item.usable?
    end
    
    should "not have uses" do
      assert !@item.uses
    end
    
    should "not have an invoke action" do
      assert !@item.invoke_action
    end
  end
end
