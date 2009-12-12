class CreateTrees < ActiveRecord::Migration
  def self.up
    create_table :trees do |t|
      t.references :treeworld, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false
      t.integer :age, :null => false, :default => 0

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :trees
  end
end
