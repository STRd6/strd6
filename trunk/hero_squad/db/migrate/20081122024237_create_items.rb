class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :null => false
      t.boolean :secondary, :null => false, :default => false

      t.integer :base_uses
      t.text :stat_mods, :null => false
      
      t.timestamps
    end
    
    Item.create({
      :name => 'Robe',
      :stat_mods => {:pow => 2},
    })
    
    Item.create({
      :name => 'Cape',
      :stat_mods => {:dex => 2, :move => 1},
    })
  
    Item.create({
      :name => 'Gauntlets',
      :stat_mods => {:str => 2},
    })
  
    Item.create({
      :name => 'Dark Robe',
      :stat_mods => {:pow => 3, :str => -2},
    })
    
    Item.create({
      :name => 'Dark Cape',
      :stat_mods => {:dex => 3, :pow => -2},
    })
  
    Item.create({
      :name => 'Dark Gauntlets',
      :stat_mods => {:str => 3, :dex => -2},
    })
  
    Item.create({
      :name => 'Grand Scian',
      :stat_mods => {:str => 1, :dex => 1, :pow => 1, :move => 1},
    })

    Item.create({
      :name => "Dragon Armor",
      :stat_mods => {:str => 1, :hp_max => 20},
    })
  
    Item.create({
      :name => "Phrygian Cap",
      :stat_mods => {:pow => 1, :en_max => 20},
    })
  
    Item.create({
      :name => "Mercenary's Arcanum",
      :stat_mods => {:en_max => 10, :hp_max => 20},
    })
  
    Item.create({
      :name => "Alchemist's Arcanum",
      :stat_mods => {:en_max => 20, :hp_max => 10},
    })

    Item.create({
      :name => "Teleport Scroll",
      :secondary => true,
    })
  
    Item.create({
      :name => "Ice Shank Scroll",
      :secondary => true,
    })
  
    Item.create({
      :name => "Fireball Scroll",
      :secondary => true,
    })
  
    Item.create({
      :name => "The Zapper",
      :secondary => true,
    })
  
    Item.create({
      :name => "Elixir",
      :secondary => true,
    })
  
    Item.create({
      :name => "Potion",
      :secondary => true,
    })
  
    Item.create({
      :name => "Ring of Vitality",
      :stat_mods => {:dex => 1, :hp_max => 10},
      :secondary => true,
    })
  
    Item.create({
      :name => "Amulet of Power",
      :stat_mods => {:pow => 1, :egen => 1},
      :secondary => true,
    })
  
    Item.create({
      :name => "Amulet of Strength",
      :stat_mods => {:str => 1, :regen => 1},
      :secondary => true,
    })
  
    Item.create({
      :name => "Ring of Endurance",
      :stat_mods => {:en_max => 10, :damage_received => -1},
      :secondary => true,
    })
  

  end

  def self.down
    drop_table :items
  end
end
