class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.references :character, :null => false
      t.references :area, :null => false
      t.references :currency, :null => false

      t.timestamps :null => false
    end

    add_index :shops, :character_id
    add_index :shops, :area_id
  end

  def self.down
    drop_table :shops
  end
end
