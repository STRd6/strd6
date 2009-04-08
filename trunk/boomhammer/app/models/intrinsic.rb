class Intrinsic < ActiveRecord::Base
  include Named
  
  belongs_to :intrinsic_base
  belongs_to :owner, :polymorphic => true

  validates_presence_of :intrinsic_base
  validates_presence_of :owner

  delegate :name, :to => :intrinsic_base
  delegate :image_file_name, :to => :intrinsic_base
end
