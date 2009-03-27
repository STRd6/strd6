class RecipeComponent < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :item_base

  validates_presence_of :recipe
  validates_presence_of :item_base
  validates_numericality_of :quantity
end
