class CharacterInstance < ActiveRecord::Base
  DEFAULT_ACTIONS = 2
  serialize :base_stats
  
  before_create :prepare_stats
  
  belongs_to :player
  belongs_to :game
  
  belongs_to :default_ability_1, :class_name => 'Ability'
  belongs_to :default_ability_2, :class_name => 'Ability'
  belongs_to :default_ability_3, :class_name => 'Ability'
  
  has_one :primary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_PRIMARY}, :include => :data
  has_one :secondary_item_card, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ITEM_SECONDARY}, :include => :data
  
  has_many :ability_cards, :class_name => 'Card', :as => :owner, :conditions => {:slot => Slot::ABILITIES}, :include => :data
  
  has_many :cards, :as => :owner
  
  validates_presence_of :name, :player, :game
  
  named_scope :in_target_with_area, lambda {|target, area|
    #TODO: Include all positions in area
    conditions = "(x = #{target[0].to_i} AND y = #{target[1].to_i})"
    {:conditions => conditions}
  }
  
  #alias :hp :hit_points 
  #alias :en :energy
  
  def character=(character)
    self.name = character.name
    self.base_stats = character.base_stats
    self.default_ability_1 = character.default_ability_1
    self.default_ability_2 = character.default_ability_2
    self.default_ability_3 = character.default_ability_3
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
  
  # Returns true if the ability was performed successfully
  # false if the ability was not performed and the data remains unchanged
  def perform_ability(ability, target_position)
    ability_attributes = ability.action_hash(self)
    area = ability_attributes[area]
    
    targets = game.character_instances.in_target_with_area(target_position, area)
    
    targets = ability.filter_targets(targets)
    
    if targets.size > 0
      transaction do
        pay_costs(ability_attributes)
        
        modified_instances = [self]

        targets.each do |target|
          # TODO: Different damages for different targets
          target.apply_effect(ability_attributes)
          target.save!
          modified_instances << target
        end
        
        # TODO: Move Effects
        
        save!
        return modified_instances
      end
    else
      false
    end
  end
  
  def apply_effect(ability_attributes)
    apply_damage ability_attributes[:damage]
    
    self.energy += ability_attributes[:energy_gain]
    
    # TODO: Special Effects
  end
  
  def apply_damage(damage)
    if damage > 0
      # Damage reduction
      net_damage = [damage + damage_received, 0].max
      
      # Absorption
      energy_absorbed = ((absorption * net_damage)/100.0).ceil
      
      self.hit_points -= net_damage
      self.energy += energy_absorbed
    end
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
    transaction do
      cards.in_slot(slot).each do |c|
        c.slot = Slot::NONE
        c.owner = player
        c.save!
      end
      
      card.slot = slot
      card.owner = self
      
      card.save!
    end
    
    reload
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
  
  # Return a list of the character's activated abilities
  def activated_abilities
    # Get a mapping of the applied abilities in each slot
    applied_abilities = ability_cards.inject({}) {|h, card| h[card.slot] = card.data if card.data.activated?; h}
    
    # Have the applied abilities overwrite the default abilities
    current_abilities = default_abilities.merge applied_abilities
    
    # Add the item abilities
    return Slot::ABILITIES.map {|slot| current_abilities[slot]}.compact + item_actions
  end
  
  def default_abilities
    {
      Slot::ABILITY_1 => default_ability_1,
      Slot::ABILITY_2 => default_ability_2,
      Slot::ABILITY_3 => default_ability_3,
    }
  end
  
  STAT_ATTRIBUTES = [:str, :dex, :pow, :move, :hp_max, :en_max, :regen, :egen, :damage_received, :absorption].freeze
  
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
    ([primary_item, secondary_item] + ability_cards.map(&:data)).compact
  end
  
  # Activated abilities granted by items
  def item_actions
    [primary_item, secondary_item].map {|item| item.invoke_action if item}.compact
  end
end
