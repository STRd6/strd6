class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :hit_points
      t.integer :energy
      t.integer :actions
      t.boolean :spent
      t.text :base_stats
      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
