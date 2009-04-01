class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :file_name, :null => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :images
  end
end
