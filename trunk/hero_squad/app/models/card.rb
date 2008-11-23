class Card < ActiveRecord::Base
  belongs_to :game
  belongs_to :card_data, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  
  def name
    card_data.name
  end
  
  def item
    card_data if card_data.instance_of?(Item)
  end
end
