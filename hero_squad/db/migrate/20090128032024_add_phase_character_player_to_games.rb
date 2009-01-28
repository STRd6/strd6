class AddPhaseCharacterPlayerToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :phase, :string
    add_column :games, :active_player, :integer
    add_column :games, :active_character, :integer
  end

  def self.down
    remove_column :games, :active_character_id
    remove_column :games, :active_player_id
    remove_column :games, :phase
  end
end
