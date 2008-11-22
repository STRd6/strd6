class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :character
      t.integer :base_uses
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
