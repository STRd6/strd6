class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.references :game, :null => false
      
      t.references :owner
      t.string :owner_type
      t.integer :slot
      
      t.references :data, :null => false
      t.string :data_type

      t.timestamps
    end
    
    add_index :cards, [:game_id, :owner_id, :owner_type]
  end

  def self.down
    drop_table :cards
  end
end
