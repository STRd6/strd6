class ShopItem < ActiveRecord::Base
  include Named

  belongs_to :shop
  belongs_to :item

  validates_presence_of :shop, :item
  validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 0

  delegate :image, :name,
    :to => :item
end
