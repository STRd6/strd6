class Card < ActiveRecord::Base
  belongs_to :game
  belongs_to :data, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  
  validates_presence_of :game, :data
  
  include RandomScope
  named_scope :unowned, :conditions => {:owner_id => nil}
  named_scope :for_player, 
    lambda { |player| {
      :conditions => {:owner_id => player.id}
    } }
  named_scope :abilities, :conditions => {:data_type => 'Ability'}
  named_scope :items, :conditions => {:data_type => 'Item'}
  named_scope :in_slot, 
    lambda { |slot| {
      :conditions => {:slot => slot}
    } }
  
  def name
    data.name
  end
  
  def css_class
    data.css_class
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
  
  def valid_for?(slot)
    if Slot::ABILITIES.include? slot
      true unless item
    elsif Slot::ITEM_PRIMARY
      true if item
    elsif Slot::ITEM_SECONDARY
      true if item
    else
      false
    end
  end
end
