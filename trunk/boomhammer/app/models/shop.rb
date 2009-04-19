class Shop < ActiveRecord::Base
  include Named
  include ItemOwner

  belongs_to :image
  belongs_to :character
  belongs_to :area
  belongs_to :currency, :class_name => "ItemBase"

  has_many :items, :as => :owner, :dependent => :destroy
  has_many :shop_items, :dependent => :destroy

  validates_presence_of :character, :area, :currency

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

  def purchase(buyer, sales_item_id, quantity=1, notifications={})
    transaction do
      if quantity > 0
        if shop_item = shop_items.find_by_id(sales_item_id)

          total_price = shop_item.price * quantity

          money = buyer.remove_item_from_base(currency, total_price)
          purchased_items = remove_item(shop_item.item, quantity)

          if money && purchased_items
            add_item(money)
            notifications[:got] = [buyer.add_item(purchased_items)]
          else
            if purchased_items
              notifications[:status] = "Insufficient money"
            else
              notifications[:status] = "Out of stock..."
            end
          end
        else
          notifications[:status] = "That item wasn't found here."
        end
      else
        notifications[:stats] = "Can't purchase a negative amount!"
      end
    end

    return notifications
  end

  def remove_inventory(item_id, notifications={})
    transaction do
      item = items.find(item_id)

      if item
        notifications[:got] = [character.add_item(item)]
        shop_item = shop_items.find_by_item_id(item.id)
        shop_item.destroy if shop_item
      else
        notifications[:status] = "That item wasn't found here."
      end
    end
    return notifications
  end

  def remove_shop_item(shop_item_id, notifications={})
    transaction do
      shop_item = shop_items.find(shop_item_id)

      if shop_item
        notifications[:got] = [character.add_item(shop_item.item)]
        shop_item.destroy
      else
        notifications[:status] = "That item wasn't found here."
      end
    end
    return notifications
  end
end
