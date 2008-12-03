class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name, :null => false
      t.boolean :public, :default => true, :null => false
      t.timestamps
    end
    
    add_index :games, :name
  end

  def self.down
    drop_table :games
  end
end
