class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :item_type, :null => false
      t.integer :x
      t.integer :y
      t.references :container, :polymorphic => true, :null => false


      t.timestamps :null => false
    end

    add_index :items, [:container_type, :container_id]
  end

  def self.down
    drop_table :items
  end
end
