class RecipeOutcome < ActiveRecord::Base
  include Named

  belongs_to :recipe
  belongs_to :item_base

  has_one :image, :through => :item_base

  validates_presence_of :recipe
  validates_presence_of :item_base
  validates_numericality_of :weight, :greater_than => 0

  delegate :name, :to => :item_base

  def self.migrate_to_events
    self.all.each do |outcome|
      outcome.recipe.add_event(outcome.item_base, outcome.weight).save!
    end
  end
end
