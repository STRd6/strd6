class CreateWindowPositions < ActiveRecord::Migration
  def self.up
    create_table :window_positions do |t|
      t.string :window
      t.integer :top
      t.integer :left
      t.integer :z
      t.references :user

      t.timestamps
    end
    
    add_index :window_positions, [:window, :user_id], :unique => true
  end

  def self.down
    drop_table :window_positions
  end
end
