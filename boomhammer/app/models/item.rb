class Item < ActiveRecord::Base
  include Named

  belongs_to :item_base
  belongs_to :owner, :polymorphic => true

  has_many :items, :dependent => :destroy

  validates_presence_of :item_base
  validates_numericality_of :quantity

  def name
    item_base.name
  end
end
