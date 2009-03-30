class RecipeOutcome < ActiveRecord::Base
  include Named

  belongs_to :recipe
  belongs_to :item_base

  validates_presence_of :recipe
  validates_presence_of :item_base

  delegate :name, :to => :item_base
end
