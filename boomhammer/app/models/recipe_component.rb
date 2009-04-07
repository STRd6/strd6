class RecipeComponent < ActiveRecord::Base
  include Named

  belongs_to :recipe
  belongs_to :item_base

  validates_presence_of :recipe, :item_base
  validates_numericality_of :quantity, :greater_than => 0
  validates_inclusion_of :consume_percentage, :in => 0..100

  delegate :name, :to => :item_base
  delegate :image_file_name, :to => :item_base

  def consume?
    consume_percentage > rand(100)
  end
end
