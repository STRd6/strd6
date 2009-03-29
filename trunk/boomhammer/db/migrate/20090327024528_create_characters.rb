class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.references :account, :null => false
      t.string :name, :null => false

      t.references :location
      t.string :location_type

      t.timestamps :null => false
    end

    add_index :characters, :account_id
    add_index :characters, [:location_id, :location_type]
  end

  def self.down
    drop_table :characters
  end
end
