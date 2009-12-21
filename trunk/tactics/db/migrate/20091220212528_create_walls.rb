class CreateWalls < ActiveRecord::Migration
  def self.up
    create_table :walls do |t|
      t.references :treeworld, :null => false
      t.integer :x1, :null => false
      t.integer :y1, :null => false
      t.integer :x2, :null => false
      t.integer :y2, :null => false

      t.timestamps :null => false
    end

    add_index :walls, :treeworld_id
  end

  def self.down
    drop_table :walls
  end
end
