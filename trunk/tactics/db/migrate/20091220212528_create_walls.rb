class CreateWalls < ActiveRecord::Migration
  def self.up
    create_table :walls do |t|
      t.references :treeworld, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false
      t.boolean :vertical, :null => false

      t.timestamps :null => false
    end

    add_index :walls, :treeworld_id
    add_index :walls, [:x, :y, :vertical], :unique => true
  end

  def self.down
    drop_table :walls
  end
end
