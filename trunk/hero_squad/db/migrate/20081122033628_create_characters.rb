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
    
    Character.create({
      :name => "Cleric",
      :base_stats => {:str => 5, :dex => 5, :pow => 5, :max_hp => 50, :max_en => 40, :move => 2}
    })
    
    Character.create({
      :name => "Fighter",
      :base_stats => {:str => 6, :dex => 5, :pow => 4, :max_hp => 50, :max_en => 30, :move => 3}
    })
    
    Character.create({
      :name => "Gladiator",
      :base_stats => {:str => 7, :dex => 4, :pow => 3, :max_hp => 60, :max_en => 20, :move => 2}
    })
    
    Character.create({
      :name => "Mage",
      :base_stats => {:str => 4, :dex => 5, :pow => 6, :max_hp => 40, :max_en => 50, :move => 3}
    })
    
    Character.create({
      :name => "Theif",
      :base_stats => {:str => 5, :dex => 6, :pow => 4, :max_hp => 40, :max_en => 40, :move => 3}
    })
    
    Character.create({
      :name => "Wizard",
      :base_stats => {:str => 3, :dex => 3, :pow => 7, :max_hp => 30, :max_en => 60, :move => 2}
    })
  end

  def self.down
    drop_table :characters
  end
end
