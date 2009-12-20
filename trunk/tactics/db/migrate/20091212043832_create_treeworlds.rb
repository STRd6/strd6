class CreateTreeworlds < ActiveRecord::Migration
  def self.up
    create_table :treeworlds do |t|
      t.integer :width, :null => false, :default => 32
      t.integer :height, :null => false, :default => 32
      t.integer :age, :null => false, :default => 0

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :treeworlds
  end
end
