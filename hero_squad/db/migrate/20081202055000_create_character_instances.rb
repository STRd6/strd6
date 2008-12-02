class CreateCharacterInstances < ActiveRecord::Migration
  def self.up
    create_table :character_instances do |t|
      t.references :character
      
      t.integer :hit_points, :null => false
      t.integer :energy, :null => false
      t.integer :actions, :null => false
      t.boolean :spent, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :character_instances
  end
end
