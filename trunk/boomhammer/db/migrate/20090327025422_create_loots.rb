class CreateLoots < ActiveRecord::Migration
  def self.up
    create_table :loots do |t|
      t.references :opportunity_base, :null => false
      t.references :item_base, :null => false
      t.integer :weight, :null => false

      t.timestamps :null => false
    end

    add_index :loots, [:opportunity_base_id, :weight]
  end

  def self.down
    drop_table :loots
  end
end
