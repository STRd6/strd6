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
  end

  def self.down
    drop_table :cards
  end
end
