class ItemBase < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :loots, :dependent => :destroy
  has_many :recipe_components, :dependent => :destroy
  has_many :recipe_outcomes, :dependent => :destroy

  def spawn(attributes={})
    item = Item.new(attributes)
    items << item
    return item
  end
end
