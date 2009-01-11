class CharacterInstance < ActiveRecord::Base
  DEFAULT_ACTIONS = 2
  
  before_create :prepare_stats
  
  belongs_to :character
  belongs_to :player
  belongs_to :game
  
  has_one :primary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}, :include => :data
  has_one :secondary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}, :include => :data
  
  has_many :ability_cards, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ABILITIES}, :include => :data
  
  validates_presence_of :character, :player, :game
  
  #alias_method :hp, :hit_points 
  #alias_method :en, :energy
  
  def name
    character.name
  end
  
  def position
    [x, y]
  end
  
  def position=(new_position)
    self.x = new_position[0]
    self.y = new_position[1]
  end
  
  def assign_ability(ability, slot)
    ability.slot = slot
    ability.owner = self
    
    CharacterInstance.transaction do
      ability_cards.in_slot(slot).each do |card|
        card.slot = Slot::NONE
        card.owner = player
        card.save!
      end
      
      ability.save!
    end
  end
  
  def base_stats
    character.base_stats
  end
  
  def dead?
    hit_points <= 0
  end
  
  def spent?
    super || dead?
  end
  
  def primary_item
    primary_item_card.data if primary_item_card
  end
  
  def secondary_item
    secondary_item_card.data if secondary_item_card
  end
  
  def abilities
    applied_abilities = ability_cards.inject({}) {|h, a| h[a.slot] = a.card_data}
    
    current_abilities = default_abilities.merge applied_abilities    
    
    return Slot::ABILITIES.map {|slot| current_abilities[slot]}.compact
  end
  
  def default_abilities
    {Slot::ABILITY_1 => :def1, Slot::ABILITY_2 => :def2, Slot::ABILITY_3 => :def3}
  end
  
  STAT_ATTRIBUTES = [:str, :dex, :pow, :move, :hp_max, :en_max, :regen, :egen, :damage_received].freeze
  
  # Define a method to access each modifiable stat attribute
  # These attributes may be modified by 
  STAT_ATTRIBUTES.each do |attr|
    if !respond_to? attr
      define_method attr do
        stat_modifiers.inject(base_stats[attr] || 0) {|memo, modifier| memo + modifier.mod_for(attr)}
      end
    else
      raise "Attempting to override an already defined method with stat attribute: #{attr}"
    end
  end
  protected
  def prepare_stats
    self.hit_points ||= hp_max
    self.energy ||= en_max
    self.actions ||= DEFAULT_ACTIONS
  end
  
  def stat_modifiers
    [primary_item, secondary_item].compact
  end
end
