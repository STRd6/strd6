class RecipeOutcome < ActiveRecord::Base
  include Named

  belongs_to :recipe
  belongs_to :item_base

  validates_presence_of :recipe
  validates_presence_of :item_base
  validates_numericality_of :weight, :greater_than => 0

  delegate :name, :to => :item_base
  delegate :image_file_name, :to => :item_base
end
