class Item < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  has_many :items, :dependent => :destroy

  validates_presence_of :item_base
  validates_numericality_of :quantity
end
