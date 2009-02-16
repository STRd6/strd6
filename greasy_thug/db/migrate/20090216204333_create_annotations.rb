class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.integer :top
      t.integer :left
      t.text :text
      t.string :url
      t.references :owner

      t.timestamps
    end
    
    add_index :annotations, :url
  end

  def self.down
    drop_table :annotations
  end
end
