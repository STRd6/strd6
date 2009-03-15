class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :identity_url, :null => false
      t.string :nickname
      t.string :email

      t.timestamps
    end
    
    add_index :players, :identity_url, :unique => true
    
    Player.create :nickname => "Player 1", :email => "test1@example.com", :identity_url => 'test1'
    Player.create :nickname => "Player 2", :email => "test2@example.com", :identity_url => 'test2'
  end

  def self.down
    drop_table :players
  end
end
