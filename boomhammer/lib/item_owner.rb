# Caller is responsible for wrapping with transactions
#
# Provides:
#   has_many :items
#   #add_item_from_base
#   #remove_item_from_base
module ItemOwner
  def self.included(model)
    model.class_eval do
      has_many :items, :as => :owner, :dependent => :destroy
    end
  end
  
  # Returns reference to existing item if any or item if none
  def add_item(item)
    #TODO: Check for echantedness
    if existing_item = items.find_by_item_base_id(item.item_base_id)
      existing_item.quantity += item.quantity
      existing_item.save!
      item.destroy

      return existing_item
    else
      items << item

      return item
    end
  end

  # Always returns the new item
  def add_item_from_base(item_base, quantity=1)
    add_knowledge(item_base)

    # If we've got one of the same stack it!
    if (item = items.find_by_item_base_id(item_base.id))
      # TODO: Maybe check for secret differences, like enchants, or bustiness
      item.quantity += quantity
      item.save!
    else
      item = item_base.spawn(:quantity => quantity)
      items << item
    end

    return item
  end

  # Always returns the removed item(s) or nil if not enough quantity or not present
  def remove_item(item, quantity)
    #TODO: Enchantyness
    return remove_item_from_base(item.item_base, quantity)
  end

  # Always returns the removed item(s) or nil if not enough quantity or not present
  def remove_item_from_base(item_base, quantity=1)
    if (item = items.find_by_item_base_id(item_base.id))
      if item.quantity >= quantity
        item.quantity -= quantity
        item.save!

        # TODO: Maybe check for secret differences, like enchants, or bustiness
        return Item.new(:item_base => item_base, :quantity => quantity)
      else
        return nil
      end
    else
      return nil
    end
  end
end
