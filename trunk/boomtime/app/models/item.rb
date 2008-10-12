class Item < ActiveRecord::Base
  include Displayable
  
  belongs_to :owner, :polymorphic => true
  
  def description
    "Lorem ipsum dolor sit amet blaw blaw. +13 Fire Damage. -7 Ice Resistance. Great against werewolves!"
  end
end
