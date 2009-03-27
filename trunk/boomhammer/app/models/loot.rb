class Loot < ActiveRecord::Base
  belongs_to :opportunity_base
  belongs_to :item_base

  validates_presence_of :opportunity_base
  validates_presence_of :item_base
end
