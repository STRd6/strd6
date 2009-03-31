class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :imageable
      t.string :imageable_type
      t.string :file_name, :null => false

      t.timestamps :null => false
    end

    add_index :images, [:imageable_id, :imageable_type]
  end

  def self.down
    drop_table :images
  end
end
