class CreateScripts < ActiveRecord::Migration
  def self.up
    create_table :scripts do |t|
      t.string :name
      t.text :code
      t.references :owner

      t.timestamps
    end
    
    add_index :scripts, :owner_id
  end

  def self.down
    drop_table :scripts
  end
end
