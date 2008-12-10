class Game < ActiveRecord::Base
  has_many :entries, :class_name => 'GameEntry'
  has_many :players, :through => :entries, :order => 'position'
  has_many :cards
  has_many :character_instances
  
  validates_presence_of :name
  
  def self.make(name, players)
    game = Game.new
    game.configure name, players
    game.save
    return game
  end
  
  def configure(name, players)
    self.name = name
    # Set up player entries
    position = 0
    players.each do |p|
      entries.build :player => p, :position => position, :game => self
      position += 1
      
      # Set up Character instances for player
      #TODO: Use character list
      Character.all.each do |character|
        character_instances.build :character => character, :player => p, :game => self
      end
    end
    
    # Create deck for game
    #TODO: Use decklists for this
    Item.all.each do |i|
      cards.build :data => i, :game => self
    end

    Ability.all.each do |a|
      cards.build :data => a, :game => self
    end
  end
  
  # Assign all unassigned cards to players evenly
  def deal
    num_players = players.size
    current_index = 0
    current_player = players[current_index]
    
    Game.transaction do
      cards.unowned.random.each do |card|
        #puts "#{card.id} - #{current_player.name}"
        
        card.owner = current_player
        card.save!
        
        current_index = (current_index + 1)%num_players
        current_player = players[current_index]
      end
    end
    
  end
  
  def cards_for_player(player)
    cards.for_player player
  end
end
