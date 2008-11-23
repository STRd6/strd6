class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name, :null => false
      
      t.integer :hit_points, :null => false
      t.integer :energy, :null => false
      t.integer :actions, :null => false
      t.boolean :spent, :default => false, :null => false
      
      t.text :base_stats, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
