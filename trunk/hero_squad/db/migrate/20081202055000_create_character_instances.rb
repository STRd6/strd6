class CreateCharacterInstances < ActiveRecord::Migration
  def self.up
    create_table :character_instances do |t|
      t.string :name, :null => false
      t.text :base_stats, :null => false
      t.references :player, :null => false
      t.references :game, :null => false
      
      t.references :default_ability_1
      t.references :default_ability_2
      t.references :default_ability_3
      
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
