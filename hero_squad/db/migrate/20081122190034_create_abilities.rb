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
        :energy_cost => '3',
        :damage => 'str/2 + 1.d(6)',
      }
    
    Ability.create :name => "Archery", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => '6',
        :damage => 'dex/2 + 1.d(6)',
        :range => '6',
        :actions_required => '2',
      }
    
    Ability.create :name => "Magic Missile", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow',
        :damage => 'pow - 4 + 1.d(6)',
        :range => '7',
        :actions_required => '2',
      }
    
    Ability.create :name => "Heal", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => '8',
        :heal => '4 + 1.d(6)',
        :range => '5',
      }
    
    Ability.create :name => "Poison", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => '7',
        :damage => 'pow/2',
        :range => '6',
      }
    
    Ability.create :name => "Bowhunting", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'str + 3',
        :damage => '(dex + str)/2 + 1.d(6)',
        :range => 'str - 1',
        :actions_required => '2',
      }
    
    Ability.create :name => "Breathsteal", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow + 1',
        :energy_damage => '(pow + dex)/2 + 1.d(6)',
      }
    
    Ability.create :name => "Energy Blast", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow + 1',
        :energy_damage => '(pow + str)/2 + 1.d(6)',
        :range => 'pow - 1',
      }
    
    Ability.create :name => "Fireball", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow*2',
        :damage => '3 + (pow/9)*3 + 1.d(6)',
        :area => 'pow/3',
        :range => '6',
      }
    
    Ability.create :name => "Frenzy", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'str + 1',
        :damage => '(str + dex)/2 + 1.d(6)',
        :area => '2',
        :range => '0',
      }
    
    Ability.create :name => "Ice Shank", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow*2',
        :damage => '(pow - 2).d(6)/2 + 2.d(6)',
      }
    
    Ability.create :name => "Lightning", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'pow + 3',
        :life_loss => 'pow - 2',
        :damage => 'pow + dex/2 + 1.d(6)',
        :range => '6',
      }
    
    Ability.create :name => "Overpower", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'str + 1',
        :life_loss => 'pow',
        :damage => 'str + pow + 1.d(6)',
      }
    
    Ability.create :name => "Pummel", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => 'max_en',
        :damage => 'str.d(6)',
      }
    
    Ability.create :name => "Teleport", 
      :activated => true,
      :attribute_expressions => {
        :energy_cost => '(dist-1)**2',
        :range => 'pow',
      }
      
    Ability.create :name => "Regeneration", 
      :activated => true,
      :stat_mods => {
        :regen => 2
      }
      
    Ability.create :name => "Resistance", 
      :activated => true,
      :stat_mods => {
        :damage_received => -2
      }
      
    Ability.create :name => "Toughness", 
      :activated => true,
      :stat_mods => {
        :damage_received => -2,
        :regen => 1
      }
      
    Ability.create :name => "Egeneration", 
      :activated => true,
      :stat_mods => {
        :egen => 3
      }
  end

  def self.down
    drop_table :abilities
  end
end
