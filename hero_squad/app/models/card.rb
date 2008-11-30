class Card < ActiveRecord::Base
  belongs_to :game
  belongs_to :data, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  
  def name
    data.name
  end
  
  def item
    data if data.instance_of?(Item)
  end
  
  def stat_mods
    data.stat_mods if data
  end
end
