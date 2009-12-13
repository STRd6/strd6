class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.references :player, :null => false
      t.string :state, :null => false
      t.string :command_type, :null => false
      t.integer :x, :null => false
      t.integer :y, :null => false

      t.timestamps :null => false
    end

    add_index :commands, :player_id
  end

  def self.down
    drop_table :commands
  end
end
