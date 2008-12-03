class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name, :null => false

      t.timestamps
    end
    
    add_index :players, :name, :unique => true
    
    Player.create :name => "Player1"
    Player.create :name => "Player2"
  end

  def self.down
    drop_table :players
  end
end
