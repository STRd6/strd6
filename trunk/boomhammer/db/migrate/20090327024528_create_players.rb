class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.references :account, :null => false
      t.string :name, :null => false

      t.references :location
      t.string :location_type

      t.timestamps :null => false
    end

    add_index :players, :account_id
    add_index :players, [:location_id, :location_type]
  end

  def self.down
    drop_table :players
  end
end
