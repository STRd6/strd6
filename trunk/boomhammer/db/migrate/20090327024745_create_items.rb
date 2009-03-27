class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :owner
      t.string :owner_type
      t.references :item_base, :null => false
      t.integer :quantity, :null => false

      t.timestamps :null => false
    end

    add_index :items, [:owner_id, :owner_type]
  end

  def self.down
    drop_table :items
  end
end
