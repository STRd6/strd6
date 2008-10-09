class CreateDisplayData < ActiveRecord::Migration
  def self.up
    create_table :display_data do |t|
      t.integer :top, :default => 0
      t.integer :left, :default => 0
      t.integer :z, :default => 0
      t.string :image
      t.references :displayable, :polymorphic => true

      t.timestamps
    end
    
    add_index :display_data, [:displayable_id, :displayable_type], :unique => true
  end

  def self.down
    drop_table :display_data
  end
end
