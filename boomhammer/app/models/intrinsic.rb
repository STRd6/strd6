class Intrinsic < ActiveRecord::Base
  include Named
  
  belongs_to :intrinsic_base
  belongs_to :owner, :polymorphic => true

  has_one :image, :through => :intrinsic_base

  validates_presence_of :intrinsic_base
  validates_presence_of :owner

  delegate :name, :to => :intrinsic_base
end
