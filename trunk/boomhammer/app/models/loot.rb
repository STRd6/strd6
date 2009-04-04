class Loot < ActiveRecord::Base
  include Named

  belongs_to :opportunity_base
  belongs_to :item_base

  validates_presence_of :opportunity_base
  validates_presence_of :item_base
  validates_numericality_of :weight, :greater_than => 0

  delegate :image_file_name, :to => :item_base
  delegate :name, :to => :item_base
end
