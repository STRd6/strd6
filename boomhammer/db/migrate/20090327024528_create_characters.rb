class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.references :account, :null => false
      t.string :name, :null => false

      t.references :area, :null => false

      t.integer :actions, :null => false, :default => 50
      t.text :intrinsics, :null => false, :default => {}

      t.timestamps :null => false
    end

    add_index :characters, :account_id
    add_index :characters, :area_id
  end

  def self.down
    drop_table :characters
  end
end
