class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.references :treeworld, :null => false
      t.references :owner, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false

      t.timestamps :null => false
    end

    add_index :houses, :treeworld_id
  end

  def self.down
    drop_table :houses
  end
end
