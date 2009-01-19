class CharacterInstance < ActiveRecord::Base
  DEFAULT_ACTIONS = 2
  
  before_create :prepare_stats
  
  belongs_to :character
  belongs_to :player
  belongs_to :game
  
  has_one :primary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}, :include => :data
  has_one :secondary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}, :include => :data
  
  has_many :ability_cards, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ABILITIES}, :include => :data
  
  has_many :cards, :as => :owner
  
  validates_presence_of :character, :player, :game
  
  named_scope :in_target_with_area, lambda {|target, area|
    #TODO: Include all positions in area
    conditions = "(x = #{target[0].to_i} AND y = #{target[1].to_i})"
    {:conditions => conditions}
  }
  
  #alias :hp, :hit_points 
  #alias :en, :energy
  
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
  
  def token_class
    entry = GameEntry.find_by_player_id_and_game_id(player_id, game_id)
    "p#{entry.position}"
  end
  
  def assign_ability(ability, slot)
    assign_card(ability, slot)
  end
  
  def perform_ability(ability, target_position)
    ability_attributes = ability.action_hash(self)
    area = ability_attributes[area]
    
    targets = game.character_instances.in_target_with_area(target_position, area)
    
    targets = ability.filter_targets(targets)
    
    if targets.size > 0
      CharacterInstance.transaction do
        pay_costs(ability_attributes)

        targets.each do |target|
          # TODO: Different damages for different targets
          target.apply_effect(ability_attributes)
          target.save!
        end
        
        # TODO: Energy gain like effects
        # TODO: Move Effects
        
        save!
      end
    end
  end
  
  def apply_effect(ability_attributes)
    # TODO: Damage reduction
    # TODO: Absorption
    self.hit_points -= ability_attributes[:damage]
    # TODO: Special Effects
  end
  
  def pay_costs(ability_attributes)
    self.energy -= ability_attributes[:energy_cost]
    self.hit_points -= ability_attributes[:life_loss]
  end
  
  def assign_primary_item(item)
    assign_card(item, Slot::ITEM_PRIMARY)
  end
  
  def assign_secondary_item(item)
    assign_card(item, Slot::ITEM_SECONDARY)
  end
  
  def assign_card(card, slot)
    card.slot = slot
    card.owner = self
    
    CharacterInstance.transaction do
      cards.in_slot(slot).each do |c|
        c.slot = Slot::NONE
        c.owner_id = player_id
        c.save!
      end
      
      card.save!
    end
    
    reload
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
