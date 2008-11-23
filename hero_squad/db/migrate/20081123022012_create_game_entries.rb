class CreateGameEntries < ActiveRecord::Migration
  def self.up
    create_table :game_entries do |t|
      t.references :player, :null => false
      t.integer :position, :null => false
      t.references :game, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :game_entries
  end
end
