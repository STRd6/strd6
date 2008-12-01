class CreateAbilities < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.string :name, :null => false
      t.boolean :activated, :null => false, :default => false
      t.text :attribute_expressions
      t.text :stat_mods, :null => false
      t.string :target_type, :null => false

      t.timestamps
    end
    
    Ability.create :name => "Strike", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 3,
        :damage => 1,
      }
  end

  def self.down
    drop_table :abilities
  end
end
