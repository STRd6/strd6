class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name, :null => false
      
      t.references :default_ability_1
      t.references :default_ability_2
      t.references :default_ability_3
      
      t.text :base_stats, :null => false
      
      t.timestamps
    end
    
    add_index :characters, :name, :unique => true
    
    Character.create({
      :name => "Cleric",
      :base_stats => {:str => 5, :dex => 5, :pow => 5, :hp_max => 50, :en_max => 40, :move => 2},
      :default_ability_1 => Ability.find_by_name("Strike"),
      :default_ability_2 => Ability.find_by_name("Heal"),
    })
    
    Character.create({
      :name => "Fighter",
      :base_stats => {:str => 6, :dex => 5, :pow => 4, :hp_max => 50, :en_max => 30, :move => 3},
      :default_ability_1 => Ability.find_by_name("Strike"),
      :default_ability_3 => Ability.find_by_name("Resistance"),
    })
    
    Character.create({
      :name => "Gladiator",
      :base_stats => {:str => 7, :dex => 4, :pow => 3, :hp_max => 60, :en_max => 20, :move => 2},
      :default_ability_1 => Ability.find_by_name("Strike"),
      :default_ability_3 => Ability.find_by_name("Regeneration"),
    })
    
    Character.create({
      :name => "Mage",
      :base_stats => {:str => 4, :dex => 5, :pow => 6, :hp_max => 40, :en_max => 50, :move => 3},
      :default_ability_1 => Ability.find_by_name("Magic Missile"),
      :default_ability_2 => Ability.find_by_name("Poison"),
    })
    
    Character.create({
      :name => "Theif",
      :base_stats => {:str => 5, :dex => 6, :pow => 4, :hp_max => 40, :en_max => 40, :move => 3},
      :default_ability_1 => Ability.find_by_name("Archery"),
      :default_ability_3 => Ability.find_by_name("Resistance"),
    })
    
    Character.create({
      :name => "Wizard",
      :base_stats => {:str => 3, :dex => 3, :pow => 7, :hp_max => 30, :en_max => 60, :move => 2},
      :default_ability_1 => Ability.find_by_name("Magic Missile"),
      :default_ability_3 => Ability.find_by_name("Egeneration"),
    })
  end

  def self.down
    drop_table :characters
  end
end
