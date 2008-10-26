class Item < ActiveRecord::Base
  include Displayable
  include Propertied
  
  belongs_to :owner, :polymorphic => true
  validates_presence_of :container_position
  
  def description
    "Lorem ipsum dolor sit amet blaw blaw. +13 Fire Damage. -7 Ice Resistance. Great against werewolves!"
  end
end
