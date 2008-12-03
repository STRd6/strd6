class Card < ActiveRecord::Base
  belongs_to :game
  belongs_to :data, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  
  validates_presence_of :game, :data
  
  def name
    data.name
  end
  
  def item
    data if data.instance_of?(Item)
  end
  
  def stat_mods
    data.stat_mods if data
  end
  
  def mod_for(stat)
    return data.mod_for(stat) if data
  end
end
