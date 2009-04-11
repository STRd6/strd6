class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :owner, :null => false
      t.string :owner_type, :null => false
      t.references :base, :null => false
      t.string :base_type, :null => false
      t.integer :weight, :default => 1, :null => false

      t.timestamps :null => false
    end

    add_index :events, [:owner_id, :owner_type]
  end

  def self.down
    drop_table :events
  end
end
