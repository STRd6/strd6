class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.references :treeworld, :null => false
      t.string :name
      t.integer :x, :null => false
      t.integer :y, :null => false

      t.timestamps :null => false
    end

    add_index :players, :treeworld_id
  end

  def self.down
    drop_table :players
  end
end
