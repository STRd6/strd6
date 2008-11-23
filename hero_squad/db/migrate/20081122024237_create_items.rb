class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :null => false

      t.integer :base_uses
      t.text :stat_mods, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
