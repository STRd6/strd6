require 'test_helper'

class ShopIntegrationTest < ActiveSupport::TestCase
  context "buying from a shop" do
    setup do
      @stock_quantity = 100
      @starting_currency = 1000
      @price = 10
      @purchase_quantity = 1

      @currency = Factory :item_base
      @character = Factory :character
      @shop = Shop.create!(:character => @character, :area => @character.area, :currency => @currency)

      @sale_item = Factory :item, :quantity => @stock_quantity
      @sale_item_base = @sale_item.item_base

      @shop_entry = @shop.add_shop_item(@sale_item, @price)

      @buyer = Factory :character
      @buyer.add_item_from_base(@currency, @starting_currency)
    end

    should "be able to purchase items at the listed prices" do
      @shop.purchase(@buyer, @shop_entry.id, @purchase_quantity)

      @buyer.reload
      buyer_currency = @buyer.items.first :conditions => {:item_base_id => @currency.id}
      assert_equal @starting_currency - @price, buyer_currency.quantity, "Buyer must pay money"

      purchased_item = @buyer.items.first :conditions => {:item_base_id => @sale_item_base.id}
      assert_equal @purchase_quantity, purchased_item.quantity, "Buyer must receive item"

      stocked_item = @shop.items.first :conditions => {:item_base_id => @sale_item_base.id}
      assert_equal @stock_quantity - @purchase_quantity, stocked_item.quantity, "Store must no longer retain item"
    end
  end
end