class CreateGameEntries < ActiveRecord::Migration
  def self.up
    create_table :game_entries do |t|
      t.references :player, :null => false
      t.integer :position, :null => false
      t.references :game, :null => false

      t.timestamps
    end
    
    # A player may only be entered once in a particular game
    add_index :game_entries, [:player_id, :game_id], :unique => true
  end

  def self.down
    drop_table :game_entries
  end
end
