class Shop < ActiveRecord::Base
  include Named
  include ItemOwner

  belongs_to :character
  belongs_to :area
  belongs_to :currency, :class_name => "ItemBase"

  has_many :items, :as => :owner, :dependent => :destroy
  has_many :shop_items, :dependent => :destroy

  validates_presence_of :character, :area, :currency

  def image
    nil
  end

  def name
    "#{character}'s Shop"
  end

  def add_shop_item(item, price)
    transaction do
      added_item = add_item(item)

      if existing_shop_item = shop_items.find_by_item_id(added_item)
        existing_shop_item.update!(:price => price)
        return existing_shop_item
      else
        new_shop_item = ShopItem.new(:item => added_item, :price => price)
        shop_items << new_shop_item
        return new_shop_item
      end
    end
  end

  def purchase(buyer, sales_item_id, quantity=1)
    transaction do
      return unless shop_item = shop_items.find(sales_item_id)

      total_price = shop_item.price * quantity

      money = buyer.remove_item_from_base(currency, total_price)
      purchased_items = remove_item(shop_item.item, quantity)

      return unless money && purchased_items

      add_item(money)
      buyer.add_item(purchased_items)
    end
  end

  def remove_shop_item(shop_item_id)
    transaction do
      shop_item = shop_items.find(shop_item_id)

      if shop_item
        character.add_item shop_item.item
        shop_item.destroy
      end
    end
  end
end
